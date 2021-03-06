class User < ActiveRecord::Base
  has_many :user_adventures
  has_many :reservations
  has_many :reviews
  has_many :adventures, through: :user_adventures
  has_many :requests
  has_many :contact_advlos
  has_many :payouts
  has_many :flags
  has_many :marketing_emails
  has_many :conversations, foreign_key: "sender_id"
  belongs_to :referrer, :class_name => "User"
  
  accepts_nested_attributes_for :user_adventures, :allow_destroy => true
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_attached_file :avatar, :styles => { :large => "600x600>", :medium => "300x300>", :profile => "250x250>", :profile_circle => "200x175>", :thumb => "65x65>"}, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  after_create :send_welcome_email
  after_create :generate_referral_code
  after_update :set_adventure_host_name


  # Overwrite password requirement for new users (i.e. generated through contacting hosts)
  def password_required?
    new_record? ? false : super
  end

  def set_adventure_host_name
    if self.name_changed?
      self.adventures.each do |a|
        a.host_name = self.get_first_name
        a.save
      end
    end
  end

  # Access token for a user's unsubscribe link
  def access_token
    User.create_access_token(self)
  end

  # Verifier based on our application secret
  def self.verifier
    ActiveSupport::MessageVerifier.new(Rails.application.secrets[:secret_key_base])
  end

  # Get a user from a token
  def self.read_access_token(signature)
    id = verifier.verify(signature)
    User.find_by_id id
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  # Class method for token generation
  def self.create_access_token(user)
    verifier.generate(user.id)
  end

  def update_referral_count
    self.referral_count += 1
    self.save

    # if self.referral_count == 5
    #   puts "************************ WE HaV3 A WiNnEr ************************"
    #   self.credit = 25.0
    #   self.save
    #   AdvloMailer.send_referral_congrats(self).deliver
    # end
  end


  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        user = User.create( 
          name: auth.extra.raw_info.name,
          avatar_url: auth.info.image,
          provider: auth.provider, 
          uid: auth.uid, 
          email: auth.info.email, 
          password: Devise.friendly_token[0,20]
        )
      end    
    end
  end

  def send_welcome_email
    AdvloMailer.delay.welcome_email(self)
    AdvloMailer.delay(run_at: 1.day.from_now).welcome_email_from_founder(self)
  end

  # Returns lat/long for now
  def get_user_geocode_info
    user_geocode_info = Hash.new
    
    geocode_obj = Geocoder.search(current_sign_in_ip)

    user_geocode_info["lat"] = geocode_obj[0].data['latitude']
    user_geocode_info["long"] = geocode_obj[0].data['longitude']

    return user_geocode_info
  end

  def is_guide?(user_id)
    @user = User.find_by!(:id => user_id)
    
    #check to verify certain parmaters exist to make sure user is eligible to be guide
    if @user.name.nil? || 
       @user.name.empty? || 
       @user.location.nil? || 
       @user.location.empty? || 
       @user.skillset.nil? || 
       @user.skillset.empty? || 
       @user.language.nil? || 
       @user.language.empty? || 
       @user.bio.nil? || 
       @user.bio.empty? || 
       @user.short_description.nil? || 
       @user.short_description.empty?
      return false
    elsif @user.avatar.url != "/images/original/missing.png"
      return true
    elsif @user.avatar_url != '' && @user.avatar_url != nil
      return true
    else
      return false
    end
  end

  def get_age
    @user = User.find_by_id!(self.id)
    now = Time.now.utc
    birthday = @user.dob
    if birthday.nil? 
      return nil
    end
    current_age = now.year - birthday.year - (birthday.to_time.change(:year => now.year) > now ? 1 : 0)
    return current_age
  end

  # STRIPE RELATED METHODS
  def stripe_recipient?
    @user = User.find_by_id(self.id)

    # Must be a host eligible
    if @user.is_guide?(@user.id)
      # Must have existing stripe recipient id
      if @user.stripe_recipient_id
        return true
      end
    else
      return false
    end
  end

  def get_avatar_url(size)
    @user = User.find_by_id(self.id)

    if @user.avatar.url != "/images/original/missing.png"
      case size
        when "thumb"
          return @user.avatar.url(:thumb)
        when "profile_circle"
          return @user.avatar.url(:profile_circle)
        when "medium"
          return @user.avatar.url(:medium)
        when "large"
          return @user.avatar.url(:large)
        when "profile"
          return @user.avatar.url(:profile)
      end
    elsif @user.avatar_url
      if size == "thumb" 
        return "#{@user.avatar_url}?type=square"
      else 
        return "#{@user.avatar_url}?type=large"
      end
    else
      return 'missing.png'
    end
      
  end

  def get_abbreviated_name
    @user = User.find_by_id(self.id)

    if @user.name
      name_split = @user.name.split(' ')
      if name_split.count > 1
        name_abbrv = "#{name_split[0]} #{name_split[name_split.length-1][0..0]}."
      else
        name_abbrv = "#{name_split[0]}"
      end
      return name_abbrv
    else
      return 'Advlo User'
    end
  end

  def get_name_and_email
    @user = User.find_by_id(self.id)

    if !@user.name.nil? && !(@user.name == '') && !@user.email.nil? && !(@user.email == '')
      return ("#{@user.get_abbreviated_name} <br> #{@user.email}").html_safe
    elsif !@user.name.nil? && !(@user.name == '') && (@user.email.nil? || @user.email == '')
      return "#{@user.get_abbreviated_name}"
    else
      return "#{@user.email}"
    end
  end

  def get_name_or_email
    @user = User.find_by_id(self.id)

    if @user.name != nil && @user.name != ''
      first_name = @user.name.split(' ')[0]
      return first_name
    else
      return @user.email
    end
  end

  def get_first_name
    @user = User.find_by_id(self.id)

    if @user.name
      name_split = @user.name.split(' ')

      return "#{name_split[0]}"
    end

  end

  def get_abbreviated_name_or_email
    @user = User.find_by_id(self.id)

    if @user.name != nil && @user.name != ''
      return @user.get_abbreviated_name
    else
      return "#{@user.email[0..@user.email.rindex('@')]}..."
    end
  end

  def calculate_rating 
    reviews = Review.where(host_id: self.id)
    @user = User.find_by_id(self.id)

    total_reviews = reviews.count
    sum_rating = 0

    reviews.each do |rev|
      sum_rating += rev.host_rating.to_f
    end

    avg_rating = sum_rating / total_reviews

    @user.rating = avg_rating.round(1)
    @user.save
  end

  def payout_via_stripe?
    user = User.find_by_id(self.id)

    if user.stripe_recipient_id
      return true
    else
      return false
    end

  end

  def payout_via_paypal?
    user = User.find_by_id(self.id)
    
    if user.paypal_email
      return true
    else
      return false
    end
  end

  def to_param
    if name
      "#{id}-#{name.gsub(' ','').gsub('.','')}"
    else
      "#{id}"
    end
  end

  def get_host_adventure_categories
    categories = []

    user = User.find(self.id)

    user.adventures.each do |adv|
      adv_cat_array = []
      adv_cat = adv.category
      adv_cat_array = adv_cat.split(',')

      adv_cat_array.each do |cat|
        categories << cat
      end
    end

    return categories.uniq.sort_by{|cat| cat.downcase}
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
    if url.include?("youtu")
      youtube_embed(url)
    elsif url.include?("vimeo")
      vimeo_embed(url)
    end
  end

  def generate_referral_code
    self.referral_code = loop do
      random_code = SecureRandom.hex(3)
      break random_code unless User.exists?(referral_code: random_code)
    end
    self.save
  end
end
