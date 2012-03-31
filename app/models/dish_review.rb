class DishReview < ActiveRecord::Base
  attr_accessible :user_id, :dish_id, :rating, :tagline, :review, :dish

  validates_presence_of :zid
  validates_uniqueness_of :zid
  before_validation(:on => :create) { set_zid }
  
  belongs_to :user
  belongs_to :visit
  belongs_to :dish
  
  has_many :pictures
    
  protected
    def set_zid
      begin
        self.zid = rand(36**12).to_s(36)
      end while self.class.find_by_zid(zid) 
    end 
 end
