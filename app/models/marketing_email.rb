class MarketingEmail < ActiveRecord::Base
  belongs_to :user


  def self.send_email_to_list(list)
    puts "***** ORIGINAL COUNT: #{list.count} *******"

    # Clean out array
    list_uniq = [];
    list_uniq = list.uniq

    puts "***** UNIQUE COUNT: #{list_uniq.count} *******"

    list_uniq.each do |g|
      if MarketingEmail.where(email: g).count > 0
        puts "************** already sent this guide an email #{g}"
      else
        puts "sending email ******** => #{g}"
        MarketingEmail.create!(title: 'Vietnam TripAdvisor Outreach', email: g)
        AdvloMailer.delay.shayan_market_host_outreach(g)
      end
    end

  end

end
