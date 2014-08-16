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

        @api = PayPal::SDK::AdaptivePayments::API.new

        # Build request object
        @pay = @api.build_pay({
          :actionType => "PAY",
          :receiverList => {
            :receiver => [{
              :amount => 10.0,
              :email => "advlo-personal@advlo.com" 
            }] 
          },
          :currencyCode => "USD",
          :cancelUrl => "http://beta.advlo.com",
          :returnUrl => "http://beta.advlo.com",
          :requestEnvelope => {
            :errorLanguage => "en_US"
          },
          :senderEmail => "paypal-facilitator@advlo.com",
          :feesPayer => "SENDER"
        })

        # Make API call & get response
        @pay_response = @api.pay(@pay)

        # Access Response
        if @pay_response.success?
          @pay_response.payKey
          @pay_response.paymentExecStatus
          @pay_response.payErrorList
          @pay_response.paymentInfoList
          @pay_response.sender
          @pay_response.defaultFundingPlan
          @pay_response.warningDataList
        else
          @pay_response.error
        end

        # Build pay object and call paypal merchant api


      end

    rescue Stripe::CardError => e
      flash[:error] = e.message
    end
  end

end
