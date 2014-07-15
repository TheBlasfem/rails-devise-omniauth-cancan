class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  attr_accessor :signin

  validates :username, uniqueness: { case_sensitive: false }

  validates_uniqueness_of :email, conditions: -> { where(provider: nil) }

  def self.find_first_by_auth_conditions(warden_conditions)
  	conditions = warden_conditions.dup
  	if signin = conditions.delete(:signin)
    	where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => signin.downcase }]).first
  	else
    	where(conditions).first
  	end
	end

  #found or create a user with remote authentication
  def self.process_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      #user.email = auth.info.email
      user.username = auth.info.nickname
    end
  end

  #tell Devise to automatically preload forms with attributes that were stored in the session
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  #Devise can skip password validation if the provider field isn't blank
  def password_required?
    super && provider.blank?
  end

  #edit your profile without password (only remote authentication)
  def update_with_password(params, *options)
    if encrypted_password.blank? && provider.present?
      update_attributes(params, *options)
    else
      super
    end
  end

  # Email is not required
  def email_required?
    false if provider.present?
  end

end
