class Reservation < ActiveRecord::Base
  belongs_to :event
	belongs_to :adventure
  belongs_to :user
	belongs_to :payout
  has_many :flags

  accepts_nested_attributes_for :user, :event

  def get_refund_amount
    reservation = Reservation.find_by_id(self.id)

    current_time = Time.now.utc

    difference = ((reservation.event_start_time - current_time)/1.hour).round

    if difference >= 48
      # User gets full refund
      return (reservation.total_price - reservation.user_fee - reservation.credit)
    else
      # User get nothing
      return 0
    end
  end

  def self.run_request_time_check 
    # Find all reservations that are in the 'requested' mode
    requested_reservations = Reservation.where(requested: true).where(cancelled: false).where("stripe_charge_id = '' OR stripe_charge_id IS NULL")

    current_time = Time.now.utc

    puts "#{current_time} - #{requested_reservations.count} REQUESTED RESERVATIONS"

    requested_reservations.each do |res|
      # Find the difference in time
      difference = ((current_time - res.created_at)/1.hour).round

      if difference >= 48
        # Host took too long to respond and cancel this reservations
        res.cancelled = true
        res.save

        host = User.find_by_id(res.host_id)

        # Generat a flag for that host
        flag_type = "#{current_time} - Request - No Response"
        flag_body = "#{current_time} - Autodecline reservation, no response from #{host.name}"

        Flag.create!(reservation_id: res.id, user_id: res.host_id, adventure_id: res.adventure_id, flag_type: flag_type, flag_body: flag_body)

        # Email the traveler
        AdvloMailer.delay.booking_request_email_rejection(res)

        puts "#{current_time} - RESERVATION ID: #{res.id} WAS AUTO-DECLINED"
      end

    end

  end

end
