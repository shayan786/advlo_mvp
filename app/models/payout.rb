class Payout < ActiveRecord::Base
  belongs_to :user
  has_many :reservations

  def self.calculate_amount_and_trigger_transfer(user_id)

    payout_user = User.find(user_id)
    unprocessed_reservations = Reservation.where(host_id: payout_user.id).where(processed: false)

    # unprocessed_reservations.where 48 hours has passed the completion date
    reservations = unprocessed_reservations.where("event_start_time < ?", DateTime.now+2)
    payout_amount = (reservations.sum(:total_price) - reservations.sum(:host_fee)).round(2)
    

    begin 
      # ---------------------- STRIPE PAYOUTS ------------------------
      if payout_user.payout_via_stripe?

        user_recip_id = payout_user.stripe_recipient_id

        @payout = Payout.create!(
          payout_via: 'stripe',
          status: 'initiated',
          stripe_recipient_id: user_recip_id,
          user_id: payout_user.id,
          amount: payout_amount*100
        )

        stripe_transfer = Stripe::Transfer.create(
          amount: @payout.amount,
          currency: 'usd',
          recipient: user_recip_id
        )
        
        @payout.stripe_transfer_id = stripe_transfer.id
        @payout.status = stripe_transfer.status
        @payout.save

        reservations.each do |reservation|
          reservation.processed = true
          reservation.payout_id = @payout.id
          reservation.save
        end
    
      # -------------------- PAYPAL PAYOUTS --------------------------
      elsif payout_user.payout_via_paypal?
        @api = Paypal::SDK::Merchant::API.new

        @payout = Payout.create!(
          payout_via: 'paypal',
          status: 'initiated',
          user_id: payout_user.id,
          amount: payout_amount
        )

        # Build mass payout object and call paypal merchant api
        @mass_pay = @api.build_mass_pay({
          :ReceiverType => "EmailAddress",
          :MassPayItem => [{
            :ReceiverEmail => payout_user.paypal_email,
            :Amount => {
              :currencyID => "USD",
              :value => payout_amount
            }
          }]
        })

        @mass_pay_response = @api.mass_pay(@mass_pay)

        if !@mass_pay_response.success?
          flash[:error] = @mass_pay_response.Errors
        end

      end

    rescue Stripe::CardError => e
      flash[:error] = e.message
    end
  end

  def get_payout_fees
    @payout = Payout.find_by_id(self.id)

    fee = @payout.amount * 0.15

    return fee.round(2)
  end

end
