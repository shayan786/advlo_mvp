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

      create_stripe_charge(total_price_cents, user.stripe_customer_id, adventure.title)
      
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
      create_stripe_charge(total_price_cents, user.stripe_customer_id, adventure.title)

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
      create_stripe_charge(total_price_cents, user.stripe_customer_id, adventure.title)


      puts "stripe id  ======>>#{@reservation.stripe_charge_id}"
      puts "cust id  ======>>#{@reservation.stripe_customer_id}"

      @reservation.stripe_charge_id = stripe_charge.id
      @reservation.stripe_customer_id = user.stripe_customer_id

      @reservation.save


      # Email both the user that request has been approved
      # AdvloMailer.
      AdvloMailer.booking_confirmation_email(@reservation)

    else
      AdvloMailer.booking_request_email_rejection(@reservation)
      @reservation.destroy

      # Email the user that request has been rejected
      # AdvloMailer.

    end

    respond_to do |format|
      format.js {render "update.js", layout: false}
    end
	end

  def create_stripe_charge(amount, customer_id, description)
    Stripe::Charge.create(
      :amount => amount,
      :currency => "usd",
      :customer => customer_id,
      :description => description
    )

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
