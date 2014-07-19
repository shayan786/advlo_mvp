module ApplicationHelper

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

  # Return array to be used for MVP - Colorado Regions for scoping adventures by region
  def adv_regions
    return ['Boulder', 'Colorado Springs', 'Denver', 'Fort Collins', 'High Rockies', 'Southern Colorado']
  end
end
