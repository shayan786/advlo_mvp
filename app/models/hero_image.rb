class HeroImage < ActiveRecord::Base
  has_attached_file :attachment, :styles => { hero: '1024x720', thumb: '250x250'}, :only_process => [:thumb], :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
  process_in_background :attachment, :only_process => [:hero]
  belongs_to :user

end
