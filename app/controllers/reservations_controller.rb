class ReservationsController < ApplicationController
	
	def create
    @reservation = Reservation.create!(reservation_params)
    total_price_cents = @reservation.total_price*100
    adventure = Adventure.find(params[:adventure_id])
    user = User.find_by_id(params[:user_id])

    if !user.stripe_customer_id.nil? && user.stripe_customer_id != ''

      Stripe::Charge.create(
        :amount => total_price_cents,
        :currency => "usd",
        :customer => user.stripe_customer_id
      )
      
    else
      customer = Stripe::Customer.create(
        :card => params[:stripe_token],
        :email => user.email,
        :description => params[:credit_card_name]
      )

      user.update(stripe_customer_id: customer.id)

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

  rescue Stripe::CardError => e
    flash[:error] = e.message
	end

	def update

	end

	def delete

	end

  private

  def reservation_params
    params.permit(
      :user_id,
      :host_id,
      :event_id,
      :total_price,
      :head_count
    )
  end
end
