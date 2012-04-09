# == Schema Information
#
# Table name: visited_store_list_entries
#
#  id                     :integer         not null, primary key
#  visitedstore_list_id   :integer
#  store_id               :integer
#  visit_cnt              :integer
#  last_visit_date        :date
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

class VisitedStoreListEntry < Obfuscatable
  attr_accessible :visited_store_list_id, :store_id, :visit_cnt, :last_visit_date

  belongs_to :visited_store_list
  belongs_to :store
end
