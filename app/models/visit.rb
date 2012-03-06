class Visit < ActiveRecord::Base
  attr_accessor :city_name, :store_name
  attr_accessible :content, :city_id, :review, :tagline, :store_id, :visit_date
  
  belongs_to :user
  has_one :store
  has_one :city
  has_many :pictures
  
  #validates :content, :presence => true, :length => { :maximum => 140 }
  #validates :user_id, :presence => true
  
  default_scope :order => 'visits.created_at DESC'
  
  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  
  def city_name
    city.name if city_id
  end
  
  def store_name
    store.name if store_id
  end
  
  def pictures?
    return pictures
  end

  private 
    def self.followed_by(user)
      following_ids = %(SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id)
      where("user_id IN (#{following_ids}) OR user_id = :user_id",
            :user_id => user)
    end
end