class VideoValidator < ActiveModel::Validator

  def validate(record)
    unless record.class != Adventure || record.class != User
      if record.video_url && !record.video_url.nil? && !(record.video_url == '')
        unless valid_url?(record.video_url)
          record.errors[:video_url] << " - Only YouTube or Vimeo URL's are allowed"
        end
      end
    end
  end

  YOUTUBE_REGEXP = /youtube.com\//
  VIMEO_REGEXP = /vimeo.com\//  

  def valid_url?(url)
    !!(YOUTUBE_REGEXP =~ url) | !!(VIMEO_REGEXP =~ url)
  end
end
