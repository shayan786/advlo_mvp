class ReservationsController < ApplicationController
	
	def create
    adventure = Adventure.find(params[:adventure_id])
    user = User.find_by_id(params[:user_id])

    # Calculate fee associated with that reservation
    # Currently fee structure
    # From Host = 15%
    # From Traveler = 4%
    host_fee = (adventure.price * params[:reservation][:head_count].to_f * 0.15).round(2)
    user_fee = (adventure.price * params[:reservation][:head_count].to_f * 0.04).round(2)

    # Stripe only takes price as cents ... convert to cents
    total_price_cents = ((params[:reservation][:total_price].to_f)*100).round(0)


    #Create a new stripe customer and get stripe information
    customer = Stripe::Customer.create(
      :card => params[:stripe_token],
      :email => user.email,
      :description => params[:credit_card_name]
    )

    # Add user stripe unique customer id to our database for future transactions
    # Taking out because stripe_customer_id is stored on reservation
    # user.update(stripe_customer_id: customer.id)

    # Now charge that customer
    stripe_charge = create_stripe_charge(total_price_cents, customer.id, adventure.title)

    # Update reservation with charge id
    if stripe_charge
      @reservation = Reservation.create!(reservation_params)
      @reservation.update(host_fee: host_fee, user_fee: user_fee)

      event = Event.find_by_id(params[:event_id])
      new_capacity = event.capacity.to_i - params[:reservation][:head_count].to_i
      event.update(capacity: new_capacity)

      @reservation.update(stripe_charge_id: stripe_charge.id)
      @reservation.update(stripe_customer_id: customer.id)
    end   

    if @reservation.save
      host = User.find(@reservation.host_id)
      AdvloMailer.delay.booking_confirmation_email_user(user, adventure, @reservation)
      AdvloMailer.delay.booking_confirmation_email_host(host, adventure, @reservation)

      respond_to do |format|
        format.js {render action: 'create.js', layout: false}
      end
    else
      format.js {render action: 'error.js', layout: false}

      flash[:notice] = "Something went wrong!"
    end

  end

  def request_time
    @reservation = Reservation.create!(request_reservation_params)
    adventure = Adventure.find_by_id(params[:adventure_id])
    user = User.find_by_id(params[:user_id])

    host_fee = (adventure.price * params[:reservation][:head_count].to_f * 0.15).round(2)
    user_fee = (adventure.price * params[:reservation][:head_count].to_f * 0.04).round(2)
    @reservation.update(host_fee: host_fee, user_fee: user_fee)

    request_date = params[:reservation_request][:date]
    request_time = params[:reservation_request][:time]

    request_date_time = (request_date+" "+request_time).to_datetime
    @reservation.event_start_time = request_date_time

    # For now, 
    # => create one
    customer = Stripe::Customer.create(
      :card => params[:stripe_token],
      :email => user.email,
      :description => params[:credit_card_name]
    )

    @reservation.stripe_customer_id = customer.id


    if @reservation.save
      AdvloMailer.delay.booking_request_email_user(@reservation)
      AdvloMailer.delay.booking_request_email_host(@reservation)

      respond_to do |format|
        format.js {render "request.js", layout: false}
      end
    else
      flash[:notice] = "Something went wrong"
    end
  end


	def update
    @reservation = Reservation.find_by_id(params[:id])
    user = User.find_by_id(@reservation.user_id)
    adventure = Adventure.find_by_id(@reservation.adventure_id)

    # Stripe only takes price as cents ... convert to cents
    total_price_cents = ((@reservation.total_price)*100).round(0)

    if params[:approve] == "true"
      # Charge the user
      stripe_charge = create_stripe_charge(total_price_cents, @reservation.stripe_customer_id, adventure.title)

      if stripe_charge
        puts "***** stripe_charge from request ====>>> #{stripe_charge} ******"

        @reservation.requested = true
        @reservation.stripe_charge_id = stripe_charge.id

        if @reservation.save
          # Email both the user that request has been approved
          # AdvloMailer
          adventure_approve = Adventure.find_by_id(@reservation.adventure_id)
          user_approve = User.find_by_id(@reservation.user_id)
          host = User.find(@reservation.host_id)

          AdvloMailer.delay.booking_confirmation_email_user(user_approve, adventure_approve, @reservation)
          AdvloMailer.delay.booking_confirmation_email_host(host, adventure_approve, @reservation)
        end

      else 
        puts "*****APPROVAL CHARGE FAILED******"
      end

    else
      AdvloMailer.booking_request_email_rejection(@reservation).deliver
      @reservation.destroy
    end

    respond_to do |format|
      format.js {render "update.js", layout: false}
    end
	end


  def host_cancel
    reservation = Reservation.find_by_id(params[:host_cancel][:reservation_id])
    cancel_reason = "HOST: #{params[:host_cancel][:reason]} - #{params[:host_cancel][:details]}"

    # Need to cancel all reservations associated with that event time || unless its requested then just take the one
    reservations_to_cancel = Reservation.where(event_id: reservation.event_id) ? Reservation.where(event_id: reservation.event_id) : reservation.to_a

    reservations_to_cancel.each do |res|
      res.cancelled = true
      res.cancel_reason = cancel_reason

      if res.save 
        # Process refunds from stripe to all users
        if res.stripe_charge_id
          charge = Stripe::Charge.retrieve(res.stripe_charge_id)
          refund = charge.refunds.create
        end        
      end
    end

    AdvloMailer.delay.host_cancel_email_to_users(res)
    AdvloMailer.delay.host_cancel_email_to_self(reservation)

    respond_to do |format|
      format.js {render "host_cancel.js", layout: false}
    end

  end

  def user_cancel 
    reservation = Reservation.find_by_id(params[:user_cancel][:reservation_id])
    event = Event.find_by_id(reservation.event_id)
    cancel_reason = "USER: #{params[:user_cancel][:reason]} - #{params[:user_cancel][:details]}"

    reservation.cancelled = true
    reservation.cancel_reason = cancel_reason


    if reservation.save
      refund_amount = reservation.get_refund_amount
      # User loses 4% no matter the cancellation
      # Determine whether cancellation is within 48 hours or not and calculate refund amount
      
      # Send emails
      AdvloMailer.delay.user_cancel_email_to_host(reservation)
      AdvloMailer.delay.user_cancel_email_to_self(reservation)

      puts "refund_amount => #{refund_amount}"

      if refund_amount != 0
        # Process refunds from stripe to that user based on the advlo's cancellation policy
        charge = Stripe::Charge.retrieve(reservation.stripe_charge_id)
      
        refund = charge.refunds.create(
          :amount => (refund_amount*100).to_i
        )

      end 

      respond_to do |format|
        format.js {render "user_cancel.js", layout: false}
      end
    end

  end

  def create_stripe_charge(amount, customer_id, description)
    puts "amount => #{amount} => #{amount.class}"
    stripe_charge =  Stripe::Charge.create(
      :amount => amount.to_i,
      :currency => "usd",
      :customer => customer_id,
      :description => description
    )

    return stripe_charge if stripe_charge

  # Stripe processing errors
  rescue Stripe::CardError => e
    flash[:error] = e.message
  end


  private

  def reservation_params
    params.required(:reservation).permit(:user_id, :host_id, :event_id, :total_price, :head_count, :adventure_id, :event_start_time, :fee)
  end

  def request_reservation_params
    params.required(:reservation).permit(:user_id, :host_id, :total_price, :requested, :adventure_id, :head_count)
  end

end
