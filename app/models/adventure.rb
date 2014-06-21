class Adventure < ActiveRecord::Base
  has_many :user_adventures
  has_many :users, through: :user_adventures
  accepts_nested_attributes_for :user_adventures, :allow_destroy => true

  has_attached_file :attachment, :styles => { :large => "600x750>", :medium => "325x285>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/

  validates_uniqueness_of :title

  before_save :set_slug
  
  #Generate display url accessable to viewers / hosts e.g. adventures/go-to-this-awesome-place
  def set_slug
    if self.slug == nil || self.slug == ''
      self.slug = self.title.gsub('-','')
                            .gsub('.','')
                            .gsub("'",'')
                            .gsub('&','')
                            .gsub(' ','-')
    end
  end
  
  #Create a new adventure
  def self.create!(options = {})
  	@adventure = Adventure.new

    
  	@adventure.save!

  	@adventure
  end


  #Edit a new adventure
  def self.edit!(options = {})

  end
end
