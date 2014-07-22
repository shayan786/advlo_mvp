class AdventureGalleryImage < ActiveRecord::Base
	belongs_to :adventure
	has_attached_file :picture, :styles => { :large => "900x900>", :thumb => "200x200>" }, :only_process => [:thumb], :default_url => "/images/:style/missing.png"
	validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/
  
  process_in_background :picture, :only_process => [:large]
end
