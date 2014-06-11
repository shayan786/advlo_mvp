class Adventure < ActiveRecord::Base
  has_attached_file :attachment, :styles => { :large => "500x500>", :medium => "325x285>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
  
end
