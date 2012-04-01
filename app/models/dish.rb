class Dish < ActiveRecord::Base
  attr_accessible :name, :store_id, :rank, :price, :code, :description, :dish_type_id, :option_description, :price_comment
  
  belongs_to :dish_type
  has_many :dish_reviews
 
  def id_encoded
    Hid.enc( self.id )
  end
  def to_param
    Hid.enc( self.id )
  end

end
