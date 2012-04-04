# == Schema Information
#
# Table name: dish_types
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#  menu_id     :integer
#  rank        :integer
#

class DishType < ActiveRecord::Base
end
