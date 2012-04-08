# == Schema Information
#
# Table name: store_list_entries
#
#  id              :integer         not null, primary key
#  store_list_id   :integer
#  store_id        :integer
#  tag             :string(255)
#  rank            :integer
#  comment         :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class VisitedStoreListEntry < ActiveRecord::Base
  attr_accessible :store_id, :visit_cnt, :last_visit_date

  belongs_to :visited_store_list
  belongs_to :store

  def id_encoded
    Hid.enc( self.id )
  end
  def to_param
    Hid.enc( self.id )
  end  
end
