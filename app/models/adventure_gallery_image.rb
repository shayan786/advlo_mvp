class AdventureGalleryImage < ActiveRecord::Base
	belongs_to :adventure

	has_attached_file :picture, :styles => { :large => "600x750>", :medium => "325x285>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  	validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
end
