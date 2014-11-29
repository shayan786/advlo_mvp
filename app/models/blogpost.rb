class Blogpost < ActiveRecord::Base
  STATE = %w(Draft Published)

  has_attached_file :attachment, :styles => { :hero => "1280X720>", :large => "600x750>", :medium => "325x285>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/

  scope :published, where('state = ?', 'Published').order('published_at DESC').limit(25)

end
