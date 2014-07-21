class User < ActiveRecord::Base
  has_many :user_adventures
  has_many :reservations
  has_many :reviews
  has_many :adventures, through: :user_adventures
  has_many :requests
  has_many :request_locations
  has_many :contact_advlos
  has_many :payouts
  
  accepts_nested_attributes_for :user_adventures, :allow_destroy => true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  #Image Magick Config.
  has_attached_file :avatar, :styles => { :large => "600x600>", :medium => "300x300>", :profile => "250x250>", :profile_circle => "200x175>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
  after_create :send_welcome_email


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
    # AdvloMailer.delay.welcome_email(self)
    AdvloMailer.welcome_email(self).deliver
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
       @user.dob.nil? || 
       @user.sex.nil? || 
       @user.sex.empty? || 
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
      return "#{@user.avatar_url}?type=large"
    else
      return 'missing.png'
    end
      
  end

  def get_name_and_email
    @user = User.find_by_id(self.id)

    if !@user.name.nil? && !(@user.name == '') && !@user.email.nil? && !(@user.email == '')
      return "#{@user.name} - #{@user.email}"
    elsif !@user.name.nil? && !(@user.name == '') && (@user.email.nil? || @user.email == '')
      return "#{@user.name}"
    else
      return "#{@user.email}"
    end
      
  end

  def calculate_rating 
    reviews = Review.where(host_id: self.id)
    @user = User.find_by_id(self.id)

    total_reviews = reviews.count
    sum_rating = 0

    reviews.each do |rev|
      sum_rating = sum_rating + rev.host_rating.to_f
    end

    avg_rating = sum_rating / total_reviews

    @user.rating = avg_rating.round(1)
    @user.save
  end

  def to_param
    if name
      "#{id}-#{name.gsub(' ','')}"
    else
      "#{id}"
    end
  end 
end
