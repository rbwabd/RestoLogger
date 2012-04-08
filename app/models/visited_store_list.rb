class VisitedStoreList < ActiveRecord::Base
  attr_accessible :id, :name, :user_id
  
  belongs_to :user
  has_many :visited_store_list_entries,  :dependent => :destroy
  has_many :stores, :through => :visited_store_list_entries

  def id_encoded
    Hid.enc( self.id )
  end
  def to_param
    Hid.enc( self.id )
  end  
end

# == Schema Information
#
# Table name: visited_store_lists
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

