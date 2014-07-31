module ApplicationHelper

  def adv_count(r)
    Adventure.where(region: r).count
  end

  def get_cities(region)
    all_cities = []
    Adventure.where(region: region).each do |a|
      all_cities << a.city
    end

    city_count = Hash.new 0
    all_cities.each do |elem|
      city_count[elem] += 1
    end
    city_locations = []
    city_count.each {|l| city_locations << l if l[1] >  1}
    return city_locations
  end

  def get_countries(region)
    all_countries = []
    Adventure.where(region: region).each do |a|
      all_countries << a.country
    end
    
    country_count = Hash.new 0
    all_countries.each do |elem|
      country_count[elem] += 1
    end
    country_locations = []
    country_count.each {|l| country_locations << l if l[1] > 1}
    return country_locations
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
end
