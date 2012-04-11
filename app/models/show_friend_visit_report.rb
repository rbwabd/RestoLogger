class ShowFriendVisitReport
  include Datagrid

  #
  # Scope
  #
  
  scope do
     Store.joins(:visits => { :user => :reverse_relationships }).where("relationships.follower_id = 21 and relationships.followed_id = visits.user_id").select("stores.id, stores.name, count(DISTINCT visits.user_id) as user_cnt").group("stores.id")
  end

  #
  # Filters
  #
  #filter(:user_id, :string) do |value|
  #  self.where(["visits.user_id = ?", Hid.dec(value)])
  #end
  filter(:store_name, :string, :header => "Name", :default => "") do |value|
    self.where(["stores.name ILIKE ?", value])
  end
  filter(:store_type, :string, :header => "Type") do |value|
    self.where(["store_types.name ILIKE ?", value])
  end
  #date_range_filters(:visit_date)

  #
  # Columns
  #
  column( :store_name, 
          :header => "Name", 
          :order => "stores.name") do |record|
    record.name
  end
  column( :store_type, :header => "Type", :order => "store_types.name" ) do |record|
    record.store_types.collect{|st| st.name}.join(", ")
  end
  column( :friends_visited, :header => "Friends that have visited" ) do |record|
    record.user_cnt
  end
  #column(:visit_date, :header => "Date")
end
