# == Schema Information
#
# Table name: active_forms
#
#  name     :
#  dish_id  :
#  price    :
#  quantity :
#

class CartItem < ActiveForm
  attr_accessible :name, :dish_id, :price, :quantity

  column :name
  column :dish_id
  column :price
  column :quantity
end
