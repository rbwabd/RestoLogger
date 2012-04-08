# == Schema Information
#
# Table name: dishes
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  alt_name           :string(255)
#  category           :integer
#  dish_type_id       :integer
#  keyword            :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  menu_id            :integer
#  rank               :integer
#  price              :float
#  price_comment      :string(255)
#  option_description :string(255)
#  pic_url            :string(255)
#  description        :string(255)
#  code               :string(255)
#  user_id            :integer
#

require 'spec_helper'

describe Dish do
  pending "add some examples to (or delete) #{__FILE__}"
end
