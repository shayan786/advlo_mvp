module ApplicationHelper

  def adv_count(r)
    Adventure.approved.where(region: r).count
  end

  def city_adv_count(c)
    Adventure.approved.where(country: c).count
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
      Struct.new("Region", :place, :count, :region) #=> Struct::Region
      hero = HeroImage.find_by_region(r[0]) ? HeroImage.find_by_region(r[0]) : HeroImage.where(region: 'default').first
      @regions << r = Struct::Region.new(r[0],r[1], hero) #=> #<struct Struct::Point x=0, y=0>
    end

    return  @regions
    # hero_image = HeroImage.find_by_region(r[0]) ? HeroImage.find_by_region(r[0]).attachment.url(:hero) : 
  end

  def get_explorer_regions
    all_cities = []
    region_count = Hash.new 0
    Adventure.approved.each do |a|
      all_cities << a.city
    end
    all_cities.each do |elem|    
      region_count[elem] += 1
    end
    hero_regions = []
    regions = region_count.each{|r| hero_regions << r[0]}
    return hero_regions
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

  def default_meta_tags
    {
      :title          => 'Advlo - Adventure Local',
      :description    => 'Advlo is a peer to peer marketplace to connect local hosts with travelers seeking to have an adventure',
      :keywords       => 'Adventure, Adventure Local, travel, tourism, booking',
      :separator      => "&mdash;".html_safe
    }
  end

  def default_og_tags
    return {
      :title          => 'Advlo - Adventure Local',
      :type           => 'website',
      :url            => "#{root_url}",
      :description    => 'Advlo is a peer to peer marketplace to connect local hosts with travelers seeking to have an adventure',
      :image          => 'http://i.imgur.com/a6L0hYB.png'
    }
  end

  def default_twitter_tags
    return {
      :card           => 'summary',
      :site           => '@advlo_',
      :title          => 'Advlo - Adventure Local',
      :description    => 'Advlo is a peer to peer marketplace to connect local hosts with travelers seeking to have an adventure',
      :image          => {
                          :_ => 'http://i.imgur.com/a6L0hYB.png'
                        }
    }
  end

  def get_meta_tags(title, description, keywords)
    return {
      :title          => "#{title} - Advlo",
      :description    => "#{description}",
      :keywords       => "Advlo, Adventure Local, Adventure with Locals, #{keywords}"
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
    return ["North America", "Europe", "Latin America", "Asia", "Africa", "Oceania"]
  end

  def host_cancellation_reasons 
    return ["Emergency", "Personal", "Travel Issues", "Weather", "Over-booked", "Other"]
  end

  def user_cancellation_reasons 
    return ["Emergency", "Personal", "Travel Issues", "Weather", "Other"]
  end
end
