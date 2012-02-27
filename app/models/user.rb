class User < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :name, :email #, :password, :password_confirmation, :remember_me
  
  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }

	has_many :authentications
  has_many :visits,    :dependent => :destroy
  has_many :relationships, :dependent => :destroy,
                           :foreign_key => "follower_id"
  has_many :reverse_relationships, :dependent => :destroy,
                                   :foreign_key => "followed_id",
                                   :class_name => "Relationship"
  has_many :following, :through => :relationships, 
											 :source => :followed
  has_many :followers, :through => :reverse_relationships, 
											 :source  => :follower
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

  def feed
    Visit.from_users_followed_by(self)
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

  def apply_omniauth(omniauth)
    case omniauth['provider']
		when 'facebook'
			self.apply_facebook(omniauth)
		end
    #creates the authentication object in database that belongs to self (user object)
		authentications.build(:provider => omniauth["provider"], :uid => omniauth["uid"], 
													:token => omniauth["credentials"]["token"])
  end
  
	def facebook
		@fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token)
	end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end	
	
	protected
		def apply_facebook(omniauth)
			self.email = omniauth["info"]["email"] if email.blank?
		  self.name = omniauth["info"]["name"] if name.blank?
		end	
end
