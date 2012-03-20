class Dish < ActiveRecord::Base
  attr_accessible :name, :store_id, :rank, :price, :code, :description, :dish_type_id, :option_description, :price_comment

  belongs_to :dish_type
  has_many :dish_reviews
end
