class VideoValidator < ActiveModel::Validator

  def validate(record)
    unless record.video_url.empty?
      unless valid_url?(record.video_url)
        record.errors[:video_url] << " - Only YouTube or Vimeo URL's are allowed"
      end
    end
  end

  YOUTUBE_REGEXP = /^(?:http:\/\/)?(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]{11})/
  VIMEO_REGEXP = /^(?:http:\/\/)?(?:www\.)?vimeo\.com\/\d{6,8}(?=\b|\/)/  

  def valid_url?(url)
    clean_url = url.gsub('https://','')
    !!(YOUTUBE_REGEXP =~ clean_url) | !!(VIMEO_REGEXP =~ clean_url)
  end
end
