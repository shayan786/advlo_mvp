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

