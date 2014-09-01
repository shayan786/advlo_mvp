module ApplicationHelper

  def check_if_advlo(user)
    if user.email == 'chrisknight.mail@gmail.com' || user.email == 'shayan@advlo.com' || user.email == 'jemaser@syr.edu'
      return true
    else
      return false
    end
  end

  def adv_count(r)
    Adventure.approved.where(region: r).count
  end

  def city_adv_count(c)
    Adventure.approved.where(country: c).count
  end

  def get_display_location(adventure)
    if adventure.region == 'North America'
      return "#{adventure.city}, #{adventure.state}".upcase
    else
      targets = adventure.location.split(',')
      first = "#{targets[0]},"
      second = targets[-1]

      if targets.count == 1 && targets[0] != 'Costa Rica'
        return "#{targets[0][0..19]}...  #{adventure.country}".upcase
      end

      if !first.include?(second)
        if first.length > 20
          first = "#{first[0..20]}..."
        end
        return "#{first} #{second}".upcase
      else
        return "#{second}".upcase
      end
    end
  end

  def get_regions
    all_cities = []
    region_count = Hash.new 0
    Adventure.approved.each do |a|
      all_cities << a.city
    end
    all_cities.compact.each do |elem|    
      region_count[elem] += 1
    end
    @regions =[]
    regions = region_count.sort_by {|key, value| key}.sort_by{|key, v| v }.reverse.take(6)

    regions.each do |r|
      Struct.new("Region", :place, :count, :region, :country) #=> Struct::Region
      hero = HeroImage.find_by_region(r[0]) ? HeroImage.find_by_region(r[0]) : HeroImage.where(region: 'default').first
      country = Adventure.find_by_city(r[0]).country
      @regions << r = Struct::Region.new(r[0],r[1], hero, country) #=> #<struct Struct::Point x=0, y=0>
    end

    return  @regions
    # hero_image = HeroImage.find_by_region(r[0]) ? HeroImage.find_by_region(r[0]).attachment.url(:hero) : 
  end

  def get_explorer_regions
    all_places = []

    Adventure.approved.each do |a|
      all_places << a.city
      all_places << a.country
      all_places << a.state
    end
    
    return all_places.uniq!
  end

  def get_cities(region)
    all_cities = []

    Adventure.approved.where(country: region).each do |a|
      all_cities << a.city
    end

    city_count = Hash.new 0
    all_cities.each do |elem|
      city_count[elem] += 1
    end
    city_locations = []
    city_count.each {|l| city_locations << l if l[1] >= 2}
    
    return city_locations
  end

  def get_countries(region)
    all_countries = []
    Adventure.approved.where(region: region).each do |a|
      all_countries << a.country
    end
    
    country_count = Hash.new 0
    all_countries.each do |elem|
      country_count[elem] += 1
    end
    country_locations = []
    country_count.each {|l| country_locations << l if l[1] >= 2}
    
    return country_locations
  end

  def get_continent(country_code)
    continents = {
      "Africa" => ["DZ","AO","DZ","AO","BJ","BW","BF","BI","CM","CV","CF","TD","KM","CD","CG","CI","DJ","EG","GQ","ER","ET","GA","GM","GH","GN","GW","KE","LS","LR","LY","MG","MW","ML","MR","MU","YT","MA","MZ","NA","NE","NG","RE","RW","SH","ST","SN","SC","SL","SO","ZA","SD","SZ","TZ","TG","TN","UG","EH","ZM","ZW"],
      "Asia" => ["AM","AZ","BH","BD","BT","IO","BN","KH","CN","CX","CC","CY","GE","HK","IN","ID","IR","IQ","IL","JP","JO","KZ","KP","KR","KW","KG","LA","LB","MO","MY","MV","MN","MM","NP","OM","PK","PS","PH","QA","SA","SG","LK","SY","TW","TJ","TH","TL","TR","TM","AE","UZ","VN","YE"],
      "Europe" => ["AX","AL","AD","AT","BY","BE","BA","BG","HR","CZ","DK","EE","FO","FI","FR","DE","GI","GR","GG","VA","HU","IS","IE","IM","IT","JE","LV","LI","LT","LU","MK","MT","MD","MC","ME","NL","NO","PL","PT","RO","RU","SM","RS","SK","SI","ES","SJ","SE","CH","UA","GB"],
      "Latin America" => ["MX","BB","BZ","CR","CU","DM","DO","SV","GD","GT","AI","AG","AW","BS","BM","VG","KY","GP","HT","HN","JM","MQ","MS","AN","NI","PA","PR","BL","KN","LC","MF","PM","VC","TT","TC","VI","AR","BO","BR","CL","CO","EC","FK","GF","GY","PY","PE","SR","UY","VE"],
      "North America" => ["US","CA","GL"],
      "Oceania" => ["AS","AU","CK","FJ","PF","GU","KI","MH","FM","NR","NC","NZ","NU","NF","MP","PW","PG","PN","WS","SB","TK","TO","TV","UM","VU","WF"]
    }

    #Find the continent and return it
    continents.each do |key,value|
      value.each do |v|
        if v == country_code
          return key
        end
      end
    end

    return "Not Found"

  end

  def get_latlong 
    countries = ["Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Ascension", "Ashmore and Cartier Islands", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Bassas da India", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bonaire", "Bosnia and Herzegovina", "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "British Virgin Islands", "Brunei", "Bulgaria", "Burkina Faso", "Burma", "Burundi", "Cambodia", "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Christmas Island", "Clipperton Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Cook Islands", "Coral Sea Islands", "Costa Rica", "Cote dIvoire", "Croatia", "Cuba", "Cura√ßao", "Cyprus", "Czech Republic", "Democratic Republic of the Congo", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Europa Island", "Falkland Islands", "Faroe Islands", "Federated States of Micronesia", "Fiji", "Finland", "France", "French Guiana", "French Polynesia", "French Southern and Antarctic Lands", "Gabon", "Gambia", "Gaza Strip", "Georgia", "Germany", "Ghana", "Gibraltar", "Glorioso Islands", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guernsey", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard Island and McDonald Islands", "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Isle of Man", "Israel", "Italy", "Jamaica", "Japan", "Jersey", "Jordan", "Juan de Nova Island", "Kazakhstan", "Kenya", "Kiribati", "Kosovo", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Macau", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Moldova", "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Namibia", "Nauru", "Nepal", "Netherlands", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "North Korea", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Pitcairn Islands", "Poland", "Portugal", "Puerto Rico", "Qatar", "Republic of the Congo", "Reunion", "Romania", "Russia", "Rwanda", "Saint Barthelemy", "Saint Kitts and Nevis", "Saint Lucia", "Saint Martin", "Saint Pierre and Miquelon", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Sint Maarten", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Georgia and South Sandwich Islands", "South Korea", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Svalbard", "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tromelin Island", "Tunisia", "Turkey", "Turkmenistan", "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "US Minor Outlying Islands", "US Virgin Islands", "Uzbekistan", "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "Wallis and Futuna", "West Bank", "Western Sahara", "Yemen", "Zambia", "Zimbabwe"]
    lat = [33,41,28,-14.3333333,42.5,-12.5,18.216667,17.05,-34,40,12.5,-15.95,-12.416667,-25,47.333333,40.5,24,26,24,13.166667,-21.416667,53,50.833333,17.25,9.5,32.333333,27.5,-17,12.2,44.25,-22,-54.433333,-10,-6,18.5,4.5,43,13,22,-3.5,13,6,60,16,19.5,7,15,-30,35,-10.5,10.283333,-12,4,-12.166667,-16.083333,-17.5,10,8,45.166667,22,12.166667,35,49.75,0,56,11.5,15.5,19,-2,27,13.833333,2,15,59,8,-22.333333,-51.75,62,5,-18,64,46,4,-15,-43,-1,13.5,31.425074,41.999981,51.5,8,36.133333,-11.5,39,72,12.116667,16.25,13.4444444,15.5,49.583333,11,12,5,19,-53,15,22.25,47,65,20,-5,32,33,53,54.25,31.5,42.833333,18.25,36,49.216667,31,-17.05833,48,1,-5,42.583333,29.5,41,18,57,33.833333,-29.5,6.5,25,47.166667,56,49.75,22.157778,41.833333,-20,-13.5,2.5,3.2,17,35.916667,10,14.666667,20,-20.3,-12.833333,23,47,43.733333,46,42.5,16.75,32,-18.25,-22,-0.533333,28,52.5,-21.5,-42,13,16,10,-19.033333,-29.033333,40,16,62,21,30,6,9,-6,-22.993333,-10,13,-25.066667,52,39.5,18.2482882,25.5,-1,-21.1,46,60,-2,17.9,17.333333,13.883333,18.075,46.833333,13.083333,-13.803096,43.933333,1,25,14,44,-4.583333,8.5,1.366667,18.04167,48.666667,46.25,-8,6,-30,-56,37,8,40,7,16,4,78,-26.5,62,47,35,24,39,-6,15,-8.833333,8,-9,-20,11,-15.866667,34,39.059012,40,21.733333,-8,2,49,24,54,39.828175,-33,5.8811111,18.3482891,41.707542,-16,41.9,8,16.166667,-13.3,31.666667,25,15.5,-15,-19]
    long = [66,20,3,-170,1.5,18.5,-63.05,-61.8,-64,45,-69.966667,-5.7,123.333333,135,13.333333,47.5,-76,50.5,90,-59.533333,39.7,28,4,-88.75,2.25,-64.75,90.5,-65,-68.25,17.833333,24,3.4,-55,72,-64.5,114.666667,25,-2,98,30,105,12,-96,-24,-80.666667,21,19,-71,105,105.666667,-109.216667,96.833333,-72,44.25,-161.583333,151,-84,-5,15.5,-79.5,-69,33,15,25,10,42.5,-61.333333,-70.666667,-77.5,30,-88.916667,10,39,26,38,40.366667,-59.166667,-7,152,178,26,2,-53,-140,67,11.75,-15.5,34.373398,43.499905,10.5,-2,-5.35,47.333333,22,-40,-61.666667,-61.583333,144.7366667,-90.25,-2.333333,-10,-15,-59,-72.416667,73,-86.5,114.166667,20,-18,77,120,53,44,-8,-4.5,34.75,12.833333,-77.5,138,-2.116667,36,42.71667,68,38,-170,21,47.75,75,105,25,35.833333,28.25,-9.5,17,9.533333,24,6.166667,113.559722,22,47,34,112.5,73,-4,14.433333,167,-61,-12,57.583333,45.166667,-102,29,7.4,105,19.3,-62.2,-5,35,17,166.916667,84,5.75,165.5,174,-85,8,8,-169.866667,167.95,127,146,10,57,70,134,-80,147,-57.996389,-76,122,-130.1,20,-8,-66.4998941,51.25,15,55.6,25,100,30,-62.833333,-62.75,-60.966667,-63.05833,-56.333333,-61.2,-172.178309,12.416667,7,45,-14,21,55.666667,-11.5,103.8,-63.06667,19.5,15.166667,159,48,26,-33,127.5,30,-4,81,30,-56,20,31.5,15,8,38,121,71,35,100,125.75,1.166667,-171.75,-175,-61,54.416667,9,34.911546,60,-71.583333,178,33,32,54,-4,-98.5795,-56,-162.0725,-64.9834807,63.84911,167,12.45,-66,107.833333,-176.2,35.25,-13.5,47.5,30,29]

    adv_countries = []
    latlong = {}

    # Find all countires uniq in our adventures
    Adventure.approved.where('country IS NOT NULL').each do |adv|
      adv_countries << adv.country
    end

    # Get unit countires
    adv_countries.uniq.each do |country|
      countries.each_with_index do |c,i|
        if c == country 
          latlong["#{c}"] = {'lat'=>lat[i],'long'=>long[i]}
        end
      end
    end

    return latlong
  end

  def default_meta_tags
    {
      :title          => 'Advlo - Adventure Local',
      :description    => 'Advlo is a peer-to-peer adventure travel marketplace where locals can create and sell unique adventure activities',
      :keywords       => 'Adventure, Adventure Travel, Adventure Local, Adventure with Locals, travel, tourism, booking, trip'
    }
  end

  def default_og_tags
    return {
      :title          => 'Advlo - Adventure Local',
      :type           => 'website',
      :url            => "#{root_url}",
      :description    => 'Advlo is a peer-to-peer adventure travel marketplace where locals can create and sell unique adventure activities',
      :image          => 'http://i.imgur.com/a6L0hYB.png'
    }
  end

  def default_twitter_tags
    return {
      :card           => 'summary',
      :site           => '@advlo_',
      :title          => 'Advlo - Adventure Local',
      :description    => 'Advlo is a peer-to-peer adventure travel marketplace where locals can create and sell unique adventure activities',
      :image          => {
                          :_ => 'http://i.imgur.com/a6L0hYB.png'
                        }
    }
  end

  def get_meta_tags(title, description, keywords)
    return {
      :title          => "#{title} - Advlo",
      :description    => "#{description}",
      :keywords       => "Adventure, Adventure Travel, Adventure Local, Adventure with Locals, travel, tourism, booking, trip, #{keywords}"
    }
  end

  def get_og_tags(title, url, description, image_src)
    return {
      :title          => "#{title}",
      :type           => 'website',
      :url            => "#{url}",
      :description    => "#{description}",
      :image          => "#{image_src}"
    }
  end

  def get_twitter_tags(title, description, image_src)
    return {
      :card           => 'summary',
      :site           => '@advlo_',
      :title          => "#{title}",
      :description    => "#{description}",
      :image          => {
                          :_ => "#{image_src}"
                        }
    }
  end

  def action_required(user)
    reservations_action_required = Reservation.where(processed: false).where(cancelled: false).where(requested: true).where(host_id: user.id).where("stripe_charge_id IS NULL OR stripe_charge_id = ''").where("event_start_time > '#{Time.now.utc}'")

    if reservations_action_required.count > 0
      return reservations_action_required.count
    else
      return false
    end
  end

  def flash_class(level)
    case level
      when 'notice' then "alert alert-info alert-block"
      when 'success' then "alert alert-success alert-block"
      when 'error' then "alert alert-error alert-block"
      when 'alert' then "alert alert-error alert-block"
    end
  end	

  # Return array to be used for adventure categories
  def adv_categories
    return ['BIKING', 'CAMPING', 'MOTOR', 'CLIMBING', 'HIKING', 'SNOW', 'WATER', 'OTHER']
  end

  def adv_regions
    return ["North America", "Latin America", "Asia", "Africa", "Oceania", "Europe"]
  end

  def host_cancellation_reasons 
    return ["Emergency", "Personal", "Travel Issues", "Weather", "Over-booked", "Other"]
  end

  def user_cancellation_reasons 
    return ["Emergency", "Personal", "Travel Issues", "Weather", "Other"]
  end
end
