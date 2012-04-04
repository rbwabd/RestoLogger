# == Schema Information
#
# Table name: store_type_relationships
#
#  id            :integer         not null, primary key
#  store_id      :integer
#  store_type_id :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class StoreTypeRelationship < ActiveRecord::Base
  attr_accessible :store_id, :store_type_id
  
  belongs_to :store
  belongs_to :store_type
end
