class Adventure < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with VideoValidator
  
  after_update :send_approval_email

  def self.approved
    where(published: true).where(approved: true)
  end

  has_many :user_adventures
  has_many :itineraries
  has_many :events
  has_many :reviews
  has_many :users, through: :user_adventures
  has_many :adventure_gallery_images
  has_many :flags

  accepts_nested_attributes_for :user_adventures, :adventure_gallery_images, :itineraries, :events, :allow_destroy => true

  has_attached_file :attachment, :styles => { :hero => "1280X720>", :large => "600x750>", :medium => "325x285>", :thumb => "100x100>" }, :only_process => [:large], :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
  process_in_background :attachment, :only_process => [:hero, :medium, :thumb]

  validates_uniqueness_of :title, :on => :update
  validates_presence_of :attachment
  validates_numericality_of :price, :on => :update
  validates_numericality_of :cap_min, :on => :update
  validates_numericality_of :cap_max, :on => :update
  validates_numericality_of :duration_num, :on => :update

  geocoded_by :location
  after_validation :geocode, :on => :update
  after_validation :reverse_geocode, :on => :update
  after_validation :set_slug, :on => :update

  after_create :check_if_adventure_unpublished

  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if results.first
      if results.first.city == nil
        city = results.first.country
      else
        city = results.first.city
      end
      if geo = results.first
        obj.city    = city
        obj.state   = geo.state
        obj.country = geo.country
      end
    else
      AdvloMailer.delay.geocode_limit_hit
    end
  end

  def set_host_name
    if self.host_name == nil || self.host_name == ''
      self.host_name = User.find(self.user_adventures.first.user_id).get_first_name
      self.save
    end
  end

  def set_slug
    if self.slug == nil || self.slug == ''
      self.slug = self.title.downcase.gsub(' ','-').gsub('.','').gsub("'",'').gsub(":",'').gsub(",",'').gsub("/",'')
      if self.slug[-1] == '-'
        self.slug = self.slug[0..-2]
      end
    end
  end


  def send_approval_email
    if self.approved == true && self.published == true && self.sent_approval_email == false
      @adventure = self
      AdvloMailer.delay.adventure_approval_accepted(@adventure)
      AdvloMailer.delay(run_at: 1.day.from_now).market_share_your_adventure_host(@adventure.users.first)

      self.sent_approval_email = true
      self.save
    else
      return
    end
  end

  def check_if_adventure_unpublished
    AdvloMailer.delay(run_at: 1.day.from_now).unpublished_adventure_email(self)
  end

  def calculate_rating 
    reviews = Review.where(adventure_id: self.id)
    @adventure = Adventure.find_by_id(self.id)

    total_reviews = reviews.count
    sum_rating = 0

    reviews.each do |rev|
      sum_rating = sum_rating + rev.get_weighted_rating
    end

    avg_rating = sum_rating / total_reviews

    @adventure.rating = avg_rating
    @adventure.save
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

  def is_subscribed_and_has_redirect_url?
    adventure = Adventure.find(self.id)
    user_adventure = UserAdventure.find_by_adventure_id(self.id)

    if user_adventure.charge_type = "subscribed" && adventure.subscription_redirect_url
      return true
    else
      return false
    end
    
  end

  def youtube_embed(youtube_url)
    if youtube_url[/yout\.be\/([^\?]*)/]
      youtube_id = $1
    else
      youtube_url[/^.*((v\/)|(embed\/)|(watch\?))\??v?=?([^\&\?]*).*/]
      youtube_id = $5
    end
    %Q{<iframe title="youTube video player" width="800" height="487.5" src="http://www.youtube.com/embed/#{ youtube_id }" frameborder="0" allowfullscreen></iframe>}
  end

  def vimeo_embed(vimeo_url)
    vimeo_id = vimeo_url.split('/')[-1]
    %Q{<iframe src="//player.vimeo.com/video/#{ vimeo_id }" width="800" height="487.5" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>}
  end

  def embed(url)
    if url.include?("youtube")
      youtube_embed(url)
    elsif url.include?("vimeo")
      vimeo_embed(url)
    end
  end
end
