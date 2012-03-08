class DishReview < ActiveRecord::Base
  belongs_to :user
  belongs_to :visit
  belongs_to :dish
  
  has_many :pictures
end
