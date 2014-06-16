class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  after_create :send_welcome_email

  # validates_presence_of :name, :avatar_url, :location, :skillset, :language, :sex, :age, :bio, :if => :is_guide?


  # def is_guide?
  #   is_guide == true
  # end

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

  def self.is_guide(user_id)
    @user = User.find_by!(:id => user_id)

    #check to verify certain parmaters exist to make sure user is eligible to be guide
    if @user.avatar_url.nil? || @user.name.nil? || @user.location.nil? || @user.skillset.nil? || @user.language.nil? || @user.age.nil? || @user.sex.nil? || @user.bio.nil?
      false
    else
      true
    end
  end

end
