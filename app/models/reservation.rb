class Reservation < ActiveRecord::Base
  belongs_to :event
	belongs_to :adventure
  belongs_to :user
	belongs_to :payout

  accepts_nested_attributes_for :user, :event

  def get_refund_amount
    reservation = Reservation.find_by_id(self.id)

    current_time = Time.now

    difference = ((reservation.event_start_time - current_time)/1.hour).round

    puts "difference ====>>> #{difference}"

    if difference >= 48
      # User gets full refund
      return (reservation.total_price - reservation.user_fee)
    else
      # User get nothing
      return 0
    end
  end

end
