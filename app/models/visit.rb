class Visit < ActiveRecord::Base
  attr_accessor :city_name, :store_name
  attr_accessible :city_name, :store_name
  
  validates_presence_of :zid
  validates_uniqueness_of :zid
  before_validation(:on => :create) { set_zid }
  
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

  protected
    def set_zid
      begin
        self.zid = rand(36**12).to_s(36)
      end while self.class.find_by_zid(zid) 
    end 
    
  private 
    def self.followed_by(user)
      following_ids = %(SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id)
      where("user_id IN (#{following_ids}) OR user_id = :user_id",
            :user_id => user)
    end
end