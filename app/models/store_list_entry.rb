# == Schema Information
#
# Table name: store_list_entries
#
#  id              :integer         not null, primary key
#  store_list_id         :integer
#  store_id   :integer
#  tag             :string(255)
#  rank            :integer
#  comment         :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class StoreListEntry < ActiveRecord::Base
  belongs_to :store_list
  has_many :store
end
