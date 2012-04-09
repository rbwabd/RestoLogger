# == Schema Information
#
# Table name: store_lists
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  name            :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  visibility_mask :integer
#

require 'spec_helper'

describe StoreList do
  pending "add some examples to (or delete) #{__FILE__}"
end
