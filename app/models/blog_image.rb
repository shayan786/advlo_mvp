class BlogImage < ActiveRecord::Base
  belongs_to :blogpost
  has_attached_file :attachment, :styles => { :large => "600x600>", :medium => "300x300>"}, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/

end
