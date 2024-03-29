# == Schema Information
#
# Table name: menus
#
#  id         :integer         not null, primary key
#  store_id   :integer
#  currency   :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Menu < Obfuscatable
  attr_accessible :currency

  belongs_to :store
  has_many :dishes, :dependent => :destroy
  
  has_paper_trail

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
  
end
