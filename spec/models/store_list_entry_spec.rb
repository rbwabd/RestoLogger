# == Schema Information
#
# Table name: store_list_entries
#
#  id         :integer         not null, primary key
#  list_id    :integer
#  store_id   :integer
#  tag        :string(255)
#  rank       :integer
#  comment    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe StoreListEntry do
  pending "add some examples to (or delete) #{__FILE__}"
end
