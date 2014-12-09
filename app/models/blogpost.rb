class Blogpost < ActiveRecord::Base
  has_many :blog_images

  has_attached_file :attachment, :styles => { :hero => "1280X720>", :large => "600x750>", :medium => "325x285>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
  process_in_background :attachment

  accepts_nested_attributes_for :blog_images, :allow_destroy => true


  STATE = %w(Draft Published)
  scope :published, where('state = ?', 'Published').order('published_at DESC').limit(25)


  def youtube_embed(youtube_url)
    if youtube_url[/yout\.be\/([^\?]*)/]
      youtube_id = $1
    else
      youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      youtube_id = $5
    end
    %Q{<iframe title="youTube video player" width="800" height="487.5" src="http://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe>}
  end

  def vimeo_embed(vimeo_url)
    vimeo_id = vimeo_url.split('/')[-1]
    %Q{<iframe src="//player.vimeo.com/video/#{ vimeo_id }" width="800" height="487.5" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>}
  end

  def embed(url)
    if url.include?("youtube")
      youtube_embed(url)
    elsif url.include?("vimeo")
      vimeo_embed(url)
    end
  end  
end
