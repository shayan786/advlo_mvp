class Adventure < ActiveRecord::Base
  before_save :set_slug

  has_many :user_adventures
  has_many :itineraries
  has_many :events
  has_many :users, through: :user_adventures
  has_many :adventure_gallery_images

  accepts_nested_attributes_for :user_adventures, :adventure_gallery_images, :itineraries, :events, :allow_destroy => true

  has_attached_file :attachment, :styles => { :hero => "1280X720>", :large => "600x750>", :medium => "325x285>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/

  validates_uniqueness_of :title
  validates_presence_of :title, :location, :summary, :cap_min, :cap_max, :duration_num, :price, :price_type
  validates_numericality_of :price, :cap_min, :cap_max, :duration_num

  geocoded_by :location
  after_validation :geocode


  def set_slug
    if self.slug == nil || self.slug == ''
      self.slug = self.title.downcase.gsub(' ','-').gsub('.','').gsub("'",'').gsub(":",'')
    end
  end

  def dur_to_sec
    if self.duration_type == "Minutes"
      sec_min = self.duration_num*60
      return sec_min
    end

    if self.duration_type == "Hours"
      sec_hour = self.duration_num*60*60
      return sec_hour
    end

    if self.duration_type == "Days"
      sec_days = self.duration_num*24*60*60
      return sec_days
    end
  end
end
