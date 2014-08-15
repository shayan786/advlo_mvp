class Payout < ActiveRecord::Base
  belongs_to :user
  has_many :reservations

  def self.calculate_amount_and_trigger_transfer(user_id)
    payout_user = User.find(user_id)
    unprocessed_reservations = Reservation.where(host_id: payout_user.id).where(processed: false).where(cancelled: false)

    # unprocessed_reservations.where 48 hours has passed the completion date    !!!!!!!!!!!
    reservations = unprocessed_reservations #.where("event_start_time < ?", DateTime.now+2)
    payout_amount = (reservations.sum(:total_price) - reservations.sum(:user_fee) - reservations.sum(:host_fee)).round(2)
    
    puts "payout_amount => #{payout_amount}"

    begin 
      # ---------------------- STRIPE PAYOUTS ------------------------
      if payout_user.payout_via_stripe?
        
        user_recip_id = payout_user.stripe_recipient_id
        amount = payout_amount

        @payout = Payout.create!(
          payout_via: 'stripe',
          status: 'initiated',
          stripe_recipient_id: user_recip_id,
          user_id: payout_user.id,
          amount: amount
        )

        stripe_transfer = Stripe::Transfer.create(
          amount: sprintf('%.0f',@payout.amount*100).to_i,
          currency: 'usd',
          recipient: user_recip_id
        )
        
        #update the payout
        @payout.stripe_transfer_id = stripe_transfer.id
        @payout.status = stripe_transfer.status
        @payout.save

        #update the reservations associated with the payout
        reservations.each do |reservation|
          reservation.processed = true
          reservation.payout_id = @payout.id
          reservation.save
        end

        
    
      # -------------------- PAYPAL PAYOUTS --------------------------
      elsif payout_user.payout_via_paypal?
        @payout = Payout.create!(
          payout_via: 'paypal',
          user_id: payout_user.id,
          amount: payout_amount
        )

        @api = PayPal::SDK::Merchant::API.new

        # Build mass payout object and call paypal merchant api

        puts "*************** @payout before ===>>> #{@payout.inspect} ***************"

        @mass_pay = @api.build_mass_pay({
          :ReceiverType => "EmailAddress",
          :MassPayItem => [{
            :ReceiverEmail => payout_user.paypal_email,
            :Amount => {
              :currencyID => "USD",
              :value => "#{sprintf('%.2f',payout_amount)}"
            }
          }]
        })

        @mass_pay_response = @api.mass_pay(@mass_pay)

        puts "***************  @mass_pay_response =====>>> #{@mass_pay_response}  ***************"

        if @mass_pay_response.success?
          #update the payout
          @payout.status = @mass_pay_response.Ack
          @payout.paypal_masspay_correlation_id = @mass_pay_response.CorrelationID
          @payout.save

          #update the reservations associated with the payout
          reservations.each do |reservation|
            reservation.processed = true
            reservation.payout_id = @payout.id
            reservation.save
          end

          #Notify host of the initiated payout
          AdvloMailer.delay.payout_completed_email(@payout)
        else
          @payout.status = 'failed'
          @payout.message = @mass_pay_response.Errors[0].LongMessage

          @payout.save
        end

      end

    rescue Stripe::CardError => e
      flash[:error] = e.message
    end
  end

end
