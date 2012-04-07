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
  attr_accessible :id, :name
  
  belongs_to :user
  has_many :store_list_entries,  :dependent => :destroy
  has_many :stores, :through => :store_list_entries
    
  def id_encoded
    Hid.enc( self.id )
  end
  def to_param
    Hid.enc( self.id )
  end
end
