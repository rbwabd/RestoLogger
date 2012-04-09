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

class Dish < Obfuscatable
  attr_accessible :user_id, :name, :menu_id, :rank, :price, :code, :description, :dish_type_id, :option_description, :price_comment
  
  belongs_to :user
  belongs_to :dish_type
  has_many :dish_reviews
  
  has_paper_trail
  
end
