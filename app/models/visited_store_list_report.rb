class VisitedStoreListReport
  include Datagrid

  #
  # Scope
  #
  
  scope do
    VisitedStoreListEntry.includes( {:store => {:store_type_relationships => :store_type}}).order("stores.name asc") 
  end

  #
  # Filters
  #
  filter(:visited_store_list_id, :integer)
  filter(:store_name, :string, :header => "Name", :default => "") do |value|
    self.where(["stores.name ILIKE ?", value])
  end
  filter(:store_type, :string, :header => "Type") do |value|
    self.where(["store_types.name ILIKE ?", value])
  end
  date_range_filters(:last_visit_date)

  #
  # Columns
  #
  column( :store_name, 
          :header => "Name", 
          :order => "stores.name",
          :url => proc {|record| Rails.application.routes.url_helpers.store_path(record.store) }) do |record|
    record.store.name
  end
  column(:store_type, :header => "Type", :order => "store_types.name") do |record|
    record.store.store_types.collect{|st| st.name}.join(", ")
  end
  column(:visit_cnt, :header => "# of visits") 
  column(:last_visit_date, :header => "Last visited")
end
