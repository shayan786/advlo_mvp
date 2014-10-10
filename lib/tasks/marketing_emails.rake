desc "This task is called by the Heroku scheduler add-on"

task :marketing_emails => :environment do

  User.all.each do |user|
    if user.adventures.approved.count > 0
      AdvloMailer.delay.market_share_your_adventure_host(user)
    else
      AdvloMailer.delay.market_one_week_last_login_user(user)
    end
    MarketingEmail.create!(title: 'One month outreach', user_id: user.id)
    puts "---------- RECORDED : sent mail to #{user.email} ----------"
  end
end




task :payout => :environment do 

  unprocessed_reservations = Reservation.where(processed: false)

  hosts_id_array = []
  unprocessed_reservations.each do |res|  
    hosts_id_array << ( User.find(res.host_id).id )
  end

  if hosts_id_array.length == 1
    hosts_with_reservations = hosts_id_array
  else
    hosts_with_reservations = hosts_id_array.uniq! 
  end


  hosts_with_reservations.each do |host_id|
    puts "Host: #{host_id} => sending payout"
    Payout.calculate_amount_and_trigger_transfer(host_id)
  end
end
