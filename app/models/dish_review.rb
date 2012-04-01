class DishReview < ActiveRecord::Base
  attr_accessible :user_id, :dish_id, :rating, :tagline, :review, :dish
  
  belongs_to :user
  belongs_to :visit
  belongs_to :dish
  
  has_many :pictures, :dependent => :destroy
    
  def id_encoded
    Hid.enc( self.id )
  end
  def to_param
    Hid.enc( self.id )
  end

end
