class Dish < ActiveRecord::Base
  attr_accessible :name, :store_id, :rank, :price, :code, :description

  has_one :dish_type
  has_many :dish_reviews
end
