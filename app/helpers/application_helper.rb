module ApplicationHelper

  def flash_class(level)
    case level
      when 'notice' then "alert alert-info alert-block"
      when 'success' then "alert alert-success alert-block"
      when 'error' then "alert alert-error alert-block"
      when 'alert' then "alert alert-error alert-block"
    end
  end	
end
