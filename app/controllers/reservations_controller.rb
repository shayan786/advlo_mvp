class ReservationsController < ApplicationController
	
	def create
    @reservation = Reservation.create!(reservation_params)

    adventure = Adventure.find(params[:adventure_id])
    user = User.find_by_id(params[:user_id])

    # Calculate fee associated with that reservation
    # Currently fee structure
    # From Host = 15%
    # From Traveler = 4%

    host_fee = (@reservation.total_price * 0.15).round(2)
    user_fee = (@reservation.total_price * 0.04).round(2)
    @reservation.update(host_fee: host_fee, user_fee: user_fee)

    # Stripe only takes price as cents ... convert to cents
    total_price_cents = ((@reservation.total_price+@reservation.user_fee)*100).round(0)

    event = Event.find_by_id(params[:event_id])
    new_capacity = event.capacity.to_i - params[:reservation][:head_count].to_i
    event.update(capacity: new_capacity)


    # If the current user (customer) is an existing stripe customer with us
    # => Create a stripe charge (i.e. charge the customer)

    if user.stripe_customer_id 

      stripe_charge = create_stripe_charge(total_price_cents, user.stripe_customer_id, adventure.title)

      # Update reservation with charge id
      if stripe_charge
        @reservation.update(stripe_charge_id: stripe_charge.id)
        @reservation.update(stripe_customer_id: user.stripe_customer_id)
      end 

    # Otherwise create a new stripe customer and get stripe information
    else
      
      customer = Stripe::Customer.create(
        :card => params[:stripe_token],
        :email => user.email,
        :description => params[:credit_card_name]
      )

      # Add user stripe unique customer id to our database for future transactions
      user.update(stripe_customer_id: customer.id)

      # Now charge that customer
      stripe_charge = create_stripe_charge(total_price_cents, user.stripe_customer_id, adventure.title)

      # Update reservation with charge id
      if stripe_charge
        @reservation.update(stripe_charge_id: stripe_charge.id)
        @reservation.update(stripe_customer_id: user.stripe_customer_id)
      end 

    end

    if @reservation.save
      # AdvloMailer.delay.booking_confirmation_email(user, adventure, @reservation)
      # AdvloMailer.booking_confirmation_email(user, adventure, @reservation).deliver

      respond_to do |format|
        format.js {render action: 'create.js', layout: false}
      end
    else
      flash[:notice] = "Something went wrong!"
    end

  end

  def request_time
    @reservation = Reservation.create!(request_reservation_params)
    user = User.find_by_id(params[:user_id])

    host_fee = (@reservation.total_price * 0.15).round(2)
    user_fee = (@reservation.total_price * 0.04).round(2)
    @reservation.update(host_fee: host_fee, user_fee: user_fee)

    adventure = Adventure.find(params[:adventure_id])

    request_date = params[:reservation_request][:date]
    request_time = params[:reservation_request][:time]

    request_date_time = (request_date+" "+request_time).to_datetime

    @reservation.event_start_time = request_date_time

    # EMAIL THE USER
    # AdvloMailer.delay.booking_confirmation_email(user, adventure, @reservation)
    # AdvloMailer.booking_confirmation_email(user, adventure, @reservation).deliver


    # EMAIL THE HOST ABOUT THIS
    # AdvloMailer.

    # If the current user (customer) does not have a stripe customer id
    # => create one
    if !user.stripe_customer_id 
      customer = Stripe::Customer.create(
        :card => params[:stripe_token],
        :email => user.email,
        :description => params[:credit_card_name]
      )

      # Add user stripe unique customer id to our database for future transactions
      user.update(stripe_customer_id: customer.id)
    end

    if @reservation.save

      AdvloMailer.booking_request_email_user(@reservation).deliver
      AdvloMailer.booking_request_email_host(@reservation).deliver

      respond_to do |format|
        format.js {render "request.js", layout: false}
      end
    else
      flash[:notice] = "Something went wrong"
    end

  # Stripe processing errors
  rescue Stripe::CardError => e
    flash[:error] = e.message
  end

	def update
    @reservation = Reservation.find_by_id(params[:id])
    user = User.find_by_id(@reservation.user_id)
    adventure = Adventure.find_by_id(@reservation.adventure_id)

    # Calculate fee associated with that reservation
    # Currently fee structure
    # From Host = 15%
    # From Traveler = 4%

    # Stripe only takes price as cents ... convert to cents
    total_price_cents = ((@reservation.total_price+@reservation.user_fee)*100).round(0)

    if params[:approve] == "true"
      @reservation.update(requested: true)

      # Charge the user
      stripe_charge = create_stripe_charge(total_price_cents, user.stripe_customer_id, adventure.title)

      @reservation.stripe_charge_id = stripe_charge.id
      @reservation.stripe_customer_id = user.stripe_customer_id

      @reservation.save

      # Email both the user that request has been approved
      # AdvloMailer
      adventure_approve = Adventure.find_by_id(@reservation.adventure_id)
      user_approve = User.find_by_id(@reservation.user_id)

      AdvloMailer.booking_confirmation_email(user_approve, adventure_approve, @reservation)

    else
      AdvloMailer.booking_request_email_rejection(@reservation)
      @reservation.destroy
    end

    respond_to do |format|
      format.js {render "update.js", layout: false}
    end
	end


  def host_cancel
    reservation = Reservation.find_by_id(params[:host_cancel][:reservation_id])
    cancel_reason = "HOST: #{params[:host_cancel][:reason]} - #{params[:host_cancel][:details]}"

    # Need to cancel all reservations associated with that event time
    reservations_to_cancel = Reservation.where(event_id: reservation.event_id)

    reservations_to_cancel.each do |res|
      res.cancelled = true
      res.cancel_reason = cancel_reason

      if res.save 
        # Process refunds from stripe to all users
        charge = Stripe::Charge.retrieve(res.stripe_charge_id)
        refund = charge.refunds.create

        # Send emails


      end
    end

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
      if refund_amount != 0
        # Process refunds from stripe to that user based on the advlo's cancellation policy
        charge = Stripe::Charge.retrieve(reservation.stripe_charge_id)
      
        refund = charge.refunds.create(
          :amount => refund_amount*100
        )
      end 

      # Send emails


      respond_to do |format|
        format.js {render "user_cancel.js", layout: false}
      end
    end

  end

  def create_stripe_charge(amount, customer_id, description)
    stripe_charge =  Stripe::Charge.create(
      :amount => amount,
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
