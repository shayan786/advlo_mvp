class MarketingEmail < ActiveRecord::Base
  belongs_to :user


  def self.send_email_to_list(list, location, by_category)
    puts "***** ORIGINAL COUNT: #{list.count} *******"

    # Clean out array
    list_uniq = [];
    list_uniq = list.uniq

    puts "***** UNIQUE COUNT: #{list_uniq.count} *******"


    if by_category == true
      activities = {
        "surfing" => ["surf", "surfing", "surfs", "surfed", "wave", "ocean", "beach"],
        "biking" => ["bike", "biking", "bicycle"],
        "hiking" => ["hike", "hiking", "climb", "climbing"],
        "trekking" => ["trekking", "trek", "camp"],
        "diving" => ["diving", "scuba", "scubadiving", "dive"],
        "fishing" => ["fish", "flyfishing"],
        "kayaking" => ["kayak"],
        "skiing" => ["ski", "skiing"],
        "snorkeling" => ["snorkel"],
        "paragliding" => ["paraglide", "paragliding"],
        "skydiving" => ["skydiving", "skydive"],
        "cultural" => ["culture"],
        "rafing" => ["raft"]
      }

      activity = nil

      list_uniq.each do |g|

        activity = nil

        activities.each do |key,value|
          value.each do |v|
            if g.include?(v)
              activity = key
              break
            end
          end
        end

        if MarketingEmail.where(email: g).count > 0
          puts "************** already sent this guide an email #{g}"
        else
          puts "sending email ******** => #{g}"
          MarketingEmail.create!(title: 'USA (Adventures Only) TripAdvisor Outreach', email: g)
          AdvloMailer.delay.shayan_market_host_outreach(g,activity,location)
        end
      end

    else
      list_uniq.each do |g|
        if MarketingEmail.where(email: g).count > 0
          puts "************** already sent this guide an email #{g}"
        else
          puts "sending email ******** => #{g}"
          MarketingEmail.create!(title: 'Vietnam TripAdvisor Outreach', email: g)
          AdvloMailer.delay.shayan_market_host_outreach(g,activity,location)
        end
      end
    end

  end

end
