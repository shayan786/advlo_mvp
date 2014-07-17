class Payout < ActiveRecord::Base
  belongs_to :user
  has_many :reservations


  def calculate_amount_and_trigger_transfer(user_id)
    payout_user = User.find(user_id)
    reservations = Reservation.where(host_id: payout_user.id).where(processed: false)

    # need to query all ^ reservations.where 48 hours has passed the completeion date

    # reservations.where("event_start_time <= ?", DateTime.now)
    # .where("created_at >= ?", Time.zone.now.beginning_of_day)

    payout_amount =  reservations.sum(:total_price)
    
    user_recip_id = payout_user.stripe_recipient_id

    @payout = Payout.create!(
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

  rescue Stripe::CardError => e
    flash[:error] = e.message
  end
end
