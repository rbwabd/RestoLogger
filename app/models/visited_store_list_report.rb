class VisitedStoreListReport
  include Datagrid

  #
  # Scope
  #
  
  scope do
    VisitedStoreListEntry.joins(:store).order("stores.name asc") 
  end

  #
  # Filters
  #
  filter(:visited_store_list_id, :integer)
  filter(:store_name, :string, :header => "Restaurant", :default => "") do |value|
    self.joins(:store).where(["stores.name ILIKE ?", value])
  end
  filter(:visit_cnt, :integer)
  date_range_filters(:last_visit_date)

  #
  # Columns
  #
  column(:store_name, :order => "stores.name") do |record|
    record.store.name
  end
  column(:visit_cnt) 
  column(:last_visit_date)
end
