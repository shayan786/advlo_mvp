class Adventure < ActiveRecord::Base
  before_save :set_slug

  has_many :user_adventures
  has_many :users, through: :user_adventures
  accepts_nested_attributes_for :user_adventures, :allow_destroy => true

  has_attached_file :attachment, :styles => { :large => "600x750>", :medium => "325x285>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/

  validates_uniqueness_of :title

  # def should_generate_new_friendly_id?
  #   new_record?
  # end
  
  #Create a new adventure
  #these methods should be handled in the controller
  def self.create!(options = {})
  	@adventure = Adventure.new
    
  	@adventure.save!

  	@adventure
  end


  #Edit a new adventure
  def self.edit!(options = {})

  end

  def set_slug
    if self.slug == nil || self.slug == ''
      self.slug = self.title.downcase.gsub(' ','').gsub('-','').gsub('.','').gsub("'",'').gsub(":",'')
    end
  end
end
