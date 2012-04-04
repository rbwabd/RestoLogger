# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  name                   :string(255)
#  profilepicurl          :string(255)
#  rank                   :string(255)
#  status                 :integer
#  first_name             :string(255)
#  last_name              :string(255)
#  birth_date             :date
#  phone                  :string(255)
#  phone2                 :string(255)
#  address                :string(255)
#  gender                 :integer
#  roles_mask             :integer
#

class User < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :name, :email, :locale, :profilepicurl, :remote_profilepicurl#, :password, :password_confirmation, :remember_me
  
  validates :name,  :presence => true, :length   => { :maximum => 50 }
  
	has_many :authentications
  has_one :user_setting

  has_many :visits,       :dependent => :destroy
  has_many :pictures,     :dependent => :destroy
  has_many :dish_reviews, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

  scope :with_role, lambda { |role| {:conditions => "roles_mask & #{2**ROLES.index(role.to_s)} > 0 "} }

  # so 1 = admin, 2 = moderator, 4 = owner and 8 = banned
  ROLES = %w[admin moderator owner banned]

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end

  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    roles.include? role.to_s
  end

  def apply_omniauth(omniauth)
    case omniauth['provider']
		when 'facebook'
			self.apply_facebook(omniauth)
    end
    #creates the authentication object in database that belongs to self (user object)
		authentications.build(:provider => omniauth["provider"], :uid => omniauth["uid"], 
													:token => omniauth["credentials"]["token"])
    build_user_setting(:locale => I18n.default_locale)
  end
  
  # i added the fetch at the end so the user data is fetched. not sure if this is a performance hit
	def facebook
		@fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token).fetch
	end

	# this is an override of a default devise method! hence the call to super
  # if authentications is not empty AND password is blank then password is not required
  # stole this code so not 100% sure why this is needed
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end	
  
  def self.localelist
    a=[[I18n.t(:english),"en"], [I18n.t(:french),"fr"],[I18n.t(:german), "de"]]
  end
  
  def locale
    user_setting.locale
  end
	
  def id_encoded
    Hid.enc( self.id )
  end
  def to_param
    Hid.enc( self.id )
  end

	protected 
    def apply_facebook(omniauth)
			self.email = omniauth["info"]["email"] if email.blank?
		  self.name = omniauth["info"]["name"] if name.blank?
		end	
end
