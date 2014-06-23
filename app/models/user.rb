class User < ActiveRecord::Base
  has_many :user_adventures
  has_many :adventures, through: :user_adventures
  accepts_nested_attributes_for :user_adventures, :allow_destroy => true
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  after_create :send_welcome_email

  #Image Magick Config.
  has_attached_file :avatar, :styles => { :large => "600x600>", :medium => "300x300>", :profile => "250x250>", :profile_circle => "200x175>", :thumb => "100x100>" }, :default_url => "/system/users/avatars/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  # validates_presence_of :name, :avatar_url, :location, :skillset, :language, :sex, :age, :bio, :if => :is_guide?


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
    Notifier.welcome_email(self).deliver
  end

  def is_guide?(user_id)
    @user = User.find_by!(:id => user_id)

    #check to verify certain parmaters exist to make sure user is eligible to be guide
    if @user.avatar_url.nil? || @user.avatar_url.empty? || @user.name.nil? || @user.name.empty? || @user.location.nil? || @user.location.empty? || @user.skillset.nil? || @user.skillset.empty? || @user.language.nil? || @user.language.empty? || @user.dob.nil? || @user.sex.nil? || @user.sex.empty? || @user.bio.nil? || @user.bio.empty? || @user.short_description.nil? || @user.short_description.empty?
      false
    else
      true
    end
  end

  def get_age(user_id)
    @user = User.find_by!(:id => user_id)

    now = Time.now.utc
    birthday = @user.dob

    if birthday.nil? 
      return nil
    end

    current_age = now.year - birthday.year - (birthday.to_time.change(:year => now.year) > now ? 1 : 0)

    return current_age
  end

  def to_param
    "#{id}-#{name.gsub(' ','')}"
  end 

end
