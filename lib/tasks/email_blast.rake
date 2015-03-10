
# cant input --param emails
namespace :email do
  desc 'Blast out emails'

  task :blast, [:addresses] => [:environment] do |task, args|
  	puts "starting blast"
    raw = args[:addresses].downcase.split(" ").map(&:to_s)

  	good_words = ['villa','cave','excursion','forest',"trek","casa","eco", "lodge", "mountain", "hotel", "flight", "rocks", "info", "galapagos", "scuba", "dive", "diving", "snorkel", "beach", "water", "marketing", "riders", "resort", "spanish", "family", "camp", "house", "earth", "life", "expeditions", "snow", "skiing", "nature", "summit", "hawaii", "holiday", "fly", "swimming", "green", "river", "experience", "club", "trees", "coastal", "odyssey", "extreme", "outdoors", "saigon", "asia", "school", "hostal", "kite", "board", "sailing", "rafting", "ocean", "sunshine", "costarica", "valley", "paragliding", "vietnam", "travel", "texas", "monkey", "skater", "mile", "creek", "kayak", "aventura", "natural", "adventure", "tours", "guide", "outfitters", "outrigger", "hike", "hostels", "adventur", "scuba", "surfing", "fish", "patrol", "freedom", "bike", "motor", "photography", "yoga", "climber", "explore", "west", "north", "south", "east", "safari", "africa", "canopy", "passport", "passion", "love", "america", "samoa", "andorra", "angola", "anguilla", "antigua", "argentina", "armenia", "aruba", "australia", "austria", "bahamas", "bahrain", "bangladesh", "barbados", "ndia", "belarus", "belgium", "belize", "benin", "bermuda", "bhutan", "bolivia", "bonaire", "botswana", "brazil", "brunei", "bulgaria", "burma", "burundi", "cambodia", "cameroon", "canada", "cape", "cayman islands", "chile", "china", "colombia", "comoros", "costa rica", "croatia", "cuba", "czech republic", "the congo", "denmark", "djibouti", "dominica", "ecuador", "egypt", "salvador", "equator", "estonia", "ethiopia", "fiji", "finland", "france", "french", "antarctic", "gabon", "gambia", "georgia", "germany", "ghana", "gibraltar", "islands", "greece", "greenland", "grenada", "guam", "guatemala", "guyana", "haiti", "honduras", "kong", "hungary", "iceland", "india", "indonesia", "iran", "iraq", "ireland", "israel", "italy", "jamaica", "japan", "jordan", "kazakhstan", "kenya", "laos", "latvia", "lebanon", "lesotho", "lithuania", "luxembourg", "macau", "macedonia", "madagascar", "malawi", "malaysia", "maldives", "mali", "malta", "martinique", "mauritania", "mauritius", "mexico", "moldova", "monaco", "mongolia", "montenegro", "montserrat", "morocco", "mozambique", "namibia", "nauru", "nepal", "netherlands", "zealand", "nicaragua", "niger", "nigeria", "niue", "korea", "norway", "pakistan", "panama", "papua", "paraguay", "peru", "philippines", "poland", "portugal", "puerto", "qatar", "congo", "reunion", "romania", "russia", "rwanda", "samoa", "san marino", "saudi", "senegal", "serbia", "seychelles", "sierra", "singapore", "slovakia", "slovenia", "solomon", "somalia", "africa", "sudan", "spain", "lanka", "sudan", "suriname", "svalbard", "swaziland", "sweden", "switzerland", "syria", "taiwan", "tajikistan", "tanzania", "thailand", "timor", "trinidad", "tunisia", "turkey", "turkmenistan", "turks", "tuvalu", "uganda", "ukraine", "united", "states", "uruguay", "vanuatu", "venezuela", "vietnam", "sahara", "yemen", "zambia", "zimbabwe", "desert","boat",'skydive','trail','canoe','sand','zipline'] 

  	bad_words = ['tripadvisor', 'png', 'jpg', 'jpeg','noreply','fyre','gadventures','austinadventures','amazon.com']

		# pickout all good keyword emails
		good = []

    raw.each do |email|
    	good_words.each do |gw|
    		if email.include?(gw)
  				good << email
  			end
  		end
    end

    puts "good count => #{good.count}"

    # remove all garbage
    raw.each do |email|
    	bad_words.each do |bw|
    		if email.include?(bw)
  				good.delete(email)
  			end
  		end
    end
    
		# unique
    good = good.uniq!

    # remove mutiple secondary domains emails

		# check to see if we have sent one & trigger blast
		good.each do |email|
			if MarketingEmail.where(email: email).count > 0
				puts "Already sent email => #{email}"
			else
				puts "SENDING ********** => #{email}"
				MarketingEmail.create!(email: email)
				MarketingMailer.delay.jon_market_host_outreach(email, 'adventure travel guides')
			end
		end
  end
end

