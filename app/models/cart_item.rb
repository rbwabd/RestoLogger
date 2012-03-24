class CartItem < ActiveForm
  attr_accessible :name, :dish_id, :price, :count

  column :name
  column :dish_id
  column :price
  column :count
end