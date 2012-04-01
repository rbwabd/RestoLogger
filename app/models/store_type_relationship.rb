class StoreTypeRelationship < ActiveRecord::Base
  attr_accessible :store_id, :store_type_id
  
  belongs_to :store
  belongs_to :store_type
end
