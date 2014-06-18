class Adventure < ActiveRecord::Base
  belongs_to :user

  has_attached_file :attachment, :styles => { :large => "600x750>", :medium => "325x285>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
  
  #Create a new adventure
  def self.create!(options = {})
  	@adventure 			= Adventure.new


  	@adventure.save!

  	@adventure
  end


  #Edit a new adventure
  def self.edit!(options = {})

  end


  #Generate display url name accessable to viewers / hosts e.g. adventures/go-to-this-awesome-place
  def self.generate_url! 

  end

end
