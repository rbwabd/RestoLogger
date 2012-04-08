class VisitedStoreListReport
  include Datagrid

  #
  # Scope
  #
  
  scope do
    VisitedStoreListEntry.where("visited_store_list_id = 2") 
  end

  #
  # Filters
  #
  
  filter(:store_name, :string)
  filter(:visit_cnt, :integer)
  date_range_filters(:last_visit_date)

  #
  # Columns
  #
  column(:store_id) do |record|
    record.store.name
  end
  column(:visit_cnt) 
  column(:last_visit_date)
end
