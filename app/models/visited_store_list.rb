class VisitedStoreList < StoreList
  has_many :visits, :through => :store_list_entries
  
end
