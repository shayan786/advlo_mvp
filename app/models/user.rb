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
  has_attached_file :avatar, :styles => { :medium => "300x300>", :profile => "250x250>", :thumb => "100x100>" }, :default_url => "/system/users/avatars/:style/missing.png"
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

  def self.is_guide?
    @user = User.find_by!(:id => current_user.id)

    #check to verify certain parmaters exist to make sure user is eligible to be guide
    if @user.avatar_url.nil? || @user.name.nil? || @user.location.nil? || @user.skillset.nil? || @user.language.nil? || @user.dob.empty? || @user.sex.nil? || @user.bio.nil?
      false
    else
      true
    end
  end

end
