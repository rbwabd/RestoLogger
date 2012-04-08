# == Schema Information
#
# Table name: stores
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  shortname     :string(255)
#  email         :string(255)
#  phone         :string(255)
#  phone2        :string(255)
#  address       :string(255)
#  postcode      :string(255)
#  city_id       :integer
#  chain_id      :integer
#  keyword       :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  user_id       :integer
#  opening_times :string(255)
#  gid           :string(255)
#

require 'spec_helper'

describe Store do
  pending "add some examples to (or delete) #{__FILE__}"
end
