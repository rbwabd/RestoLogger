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

class User < Obfuscatable
  attr_accessor   :password
  attr_accessible :name, :email, :locale, :profilepicurl, :remote_profilepicurl#, :password, :password_confirmation, :remember_me

  validates :name,  :presence => true, :length   => { :maximum => 50 }
  
  has_one  :user_setting,       :dependent => :destroy
  has_one  :profile_picture,    :dependent => :destroy
  has_many :authentications,    :dependent => :destroy
  has_many :visits,             :dependent => :destroy
  has_many :pictures,           :dependent => :destroy
  has_many :dish_reviews   #2do: dish_reviews destroyed through visits, maybe this should be a "through" relationship
  has_one  :visited_store_list, :dependent => :destroy
  has_many :store_lists,        :dependent => :destroy

  has_many :relationships,          :dependent => :destroy, :foreign_key => "follower_id"
  has_many :reverse_relationships,  :dependent => :destroy, :foreign_key => "followed_id", :class_name => "Relationship"
  has_many :following, :through => :relationships,         :source => :followed
  has_many :followers, :through => :reverse_relationships, :source  => :follower
                       
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
  end
  
  # i added the fetch at the end so the user data is fetched. not sure if this is a performance hit
	# 2do: check where this is called, not clear to me if used at all
  def facebook
		@fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token).fetch
	end

  def load_fb_friends(token)
    f_list = FbGraph::User.me(token).fetch.friends
    for friend in f_list
      # 2do: find a more efficient way of making less DB queries
      p friend.identifier
      auth = Authentication.where("provider = 'facebook' and uid = ?", friend.identifier).first
      if auth
        Relationship.find_or_create_by_followed_id_and_follower_id( :followed_id => self.id, :follower_id => auth.user_id )
        Relationship.find_or_create_by_followed_id_and_follower_id( :followed_id => auth.user_id, :follower_id => self.id,  )
      end
    end
  end

  def following?(followed)
    relationships.find_by_followed_id(followed)
  end
  
  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
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

  # should not override initialize as activerecord calls it
  def init_routine
    #set normal user role without any special qualifiers
    self.roles_mask = 0
    #create visited_stores_list
    self.build_visited_store_list
    #default favourites list
    self.store_lists.build( :name => I18n.t("store_lists.default_store_list") )
    self.build_user_setting(:locale => I18n.default_locale)
  end    

	protected 
    def apply_facebook(omniauth)
			self.email = omniauth["info"]["email"] if email.blank?
		  self.name = omniauth["info"]["name"] if name.blank?
		end	
end
