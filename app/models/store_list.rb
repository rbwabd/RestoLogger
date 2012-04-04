# == Schema Information
#
# Table name: store_lists
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class StoreList < ActiveRecord::Base

  has_many :store_list_entries
end
