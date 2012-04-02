class Menu < ActiveRecord::Base
  attr_accessible :currency
  has_many :dishes, :dependent => :destroy

  def get_dish_hash
    store_dishes = dishes.sort_by { |a| [a.dish_type.rank, a.rank] }
    #use number_to_currency to fix price display <%= number_to_currency(product.price) %>
    dish_hash = Hash.new
    store_dishes.each do |dish|
      dtn = dish.dish_type.name
      if !dish_hash.has_key?(dtn)
        dish_hash[dtn] = Array.new
      end
      dish_hash[dtn] << dish
    end
    return dish_hash
  end  
  
  def id_encoded
    Hid.enc( self.id )
  end
  def to_param
    Hid.enc( self.id )
  end
end
