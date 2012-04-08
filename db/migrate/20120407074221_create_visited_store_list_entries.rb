class CreateVisitedStoreListEntries < ActiveRecord::Migration
  def change
    create_table :visited_store_list_entries do |t|
      t.integer :store_list_id
      t.integer :store_id
      t.integer :visit_cnt
      t.date :last_visit_date 

      t.timestamps
    end
  end
end
