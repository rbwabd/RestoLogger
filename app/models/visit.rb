class Visit < ActiveRecord::Base
  attr_accessor :city_name, :store_name
  attr_accessible :city_name, :store_name, :visit_date
  
  belongs_to :user
  belongs_to :store
  belongs_to :city
  has_many :dish_reviews, :dependent => :destroy
  has_many :pictures, :dependent => :destroy

  #validates :content, :presence => true, :length => { :maximum => 140 }
  #validates :user_id, :presence => true
  
  default_scope :order => 'visits.created_at DESC'
  
  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  
  def pictures?
    return pictures
  end

  def id_encoded
    Hid.enc( self.id )
  end
  def to_param
    Hid.enc( self.id )
  end
  
  private 
    def self.followed_by(user)
      following_ids = %(SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id)
      where("user_id IN (#{following_ids}) OR user_id = :user_id",
            :user_id => user)
    end
end