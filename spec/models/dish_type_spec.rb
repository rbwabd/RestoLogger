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

require 'spec_helper'

describe DishType do
  pending "add some examples to (or delete) #{__FILE__}"
end
