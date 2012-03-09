class DishReview < ActiveRecord::Base
  attr_accessible :user_id, :dish_id
  
  belongs_to :user
  belongs_to :visit
  belongs_to :dish
  
  has_many :pictures
end
