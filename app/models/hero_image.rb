class HeroImage < ActiveRecord::Base
  has_attached_file :attachment, :styles => { hero: '1024x440', thumb: '100x100'}
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/

end
