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

  def self.send_email_to_bloggers_about_affiliate_program
    bloggers_name = ['Seth','Matthew','Cam & Nicole','Kate','Gary','Devin','Audrey','Sam & Zab','Andi','Amanda','Fran','Shalee','Stephanie','Traci','Tiffiny','Pavel','Benjamin','Matt','Katie','Landon','Paul']
    bloggers_email = ['sethandtana@gmail.com','matt@expertvagabond.com','cam@travelingcanucks.com','kate@adventurouskate.com','gary@everything-everywhere.com', 'new@devinthorpe.com','bergner.audrey@gmail.com','indefiniteadventure@gmail.com','AndiPerullo@aol.com','TheAmandaWoods@gmail.com','fran@franreisner.com','shaleewanders@gmail.com','justcherishedblog@gmail.com','Traci@walksimply.com','turbotiffiny@gmail.com','pavel.gospodinov@me.com','benjamin@adventuresauce.com','xpatmatt@gmail.com','katie@adventure-inspired.com','landonbfaulkner@gmail.com','paul.osborn@theoutdooradventure.net']

    bloggers_name.each_with_index do |b,i|
      AdvloMailer.blogger_affiliate_outreach(bloggers_email[i],b).deliver
    end
  end

end
