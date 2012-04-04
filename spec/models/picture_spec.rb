# == Schema Information
#
# Table name: pictures
#
#  id             :integer         not null, primary key
#  genre          :string(255)
#  filename       :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  image          :string(255)
#  url            :string(255)
#  tagline        :string(255)
#  description    :string(255)
#  user_id        :integer
#  visit_id       :integer
#  dish_review_id :integer
#  store_id       :integer
#  vote_count     :integer
#  perimated      :integer
#  rank           :integer
#

require 'spec_helper'

describe Picture do
  pending "add some examples to (or delete) #{__FILE__}"
end
