class Dish < ActiveRecord::Base
  attr_accessible :name, :store_id, :rank, :price, :code, :description, :dish_type_id, :option_description, :price_comment

  validates_presence_of :zid
  validates_uniqueness_of :zid
  before_validation(:on => :create) { set_zid }
  
  belongs_to :dish_type
  has_many :dish_reviews

  protected
    def set_zid
      begin
        self.zid = rand(36**12).to_s(36)
      end while self.class.find_by_zid(zid) 
    end   
end
