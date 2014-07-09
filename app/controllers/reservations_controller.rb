class ReservationsController < ApplicationController
	
	def create
    @reservation = Reservation.create!(reservation_params)

    # Stripe only takes price as cents ... convert to cents
    total_price_cents = @reservation.total_price*100

    adventure = Adventure.find(params[:adventure_id])
    user = User.find_by_id(params[:user_id])

    # If the current user (customer) is an existing stripe customer with us
    # => Create a stripe charge (i.e. charge the customer)
    if !user.stripe_customer_id.nil? && user.stripe_customer_id != ''

      Stripe::Charge.create(
        :amount => total_price_cents,
        :currency => "usd",
        :customer => user.stripe_customer_id
      )
      
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
      Stripe::Charge.create(
        :amount => total_price_cents,
        :currency => "usd",
        :customer => user.stripe_customer_id,
        :description => adventure.title
      )

    end

    if @reservation.save
      respond_to do |format|
        format.js {render action: 'create.js', layout: false}
      end
    else
      flash[:notice] = "NOOOOO"
    end

  # Stripe processing errors
  rescue Stripe::CardError => e
    flash[:error] = e.message
	end

	def update

	end

	def delete

	end

  private

  def reservation_params
    params.required(:reservation).permit(:user_id, :host_id, :event_id, :total_price, :head_count, :adventure_id)
  end
end
