# == Schema Information
#
# Table name: visited_store_lists
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#
class VisitedStoreList < Obfuscatable
  attr_accessible :id, :name, :user_id
  
  belongs_to :user
  has_many :visited_store_list_entries,  :dependent => :destroy
  has_many :stores, :through => :visited_store_list_entries

end



