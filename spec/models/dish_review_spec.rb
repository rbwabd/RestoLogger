# == Schema Information
#
# Table name: dish_reviews
#
#  id         :integer         not null, primary key
#  rating     :integer
#  tagline    :string(255)
#  review     :text
#  dish_id    :integer
#  user_id    :integer
#  visit_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  quantity   :integer
#  perimated  :integer
#  rank       :integer
#

require 'spec_helper'

describe DishReview do
  pending "add some examples to (or delete) #{__FILE__}"
end
