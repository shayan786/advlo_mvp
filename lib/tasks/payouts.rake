task :payout => :environment do 

  unprocessed_reservations = Reservation.where(processed: false)

  hosts_with_reservations = []
  unprocessed_reservations.each do |res|  
    hosts_with_reservations << ( User.find(res.host_id).id )
  end

  hosts_with_reservations.uniq!.each do |host_id|
    puts "Host: #{host_id} => sending payout"
    Payout.calculate_amount_and_trigger_transfer(host_id)
  end
end
