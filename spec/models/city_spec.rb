# == Schema Information
#
# Table name: cities
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  location   :string(255)
#  country_id :integer
#  state_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe City do
  pending "add some examples to (or delete) #{__FILE__}"
end
