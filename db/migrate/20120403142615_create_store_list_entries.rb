class CreateStoreListEntries < ActiveRecord::Migration
  def change
    create_table :store_list_entries do |t|
      t.integer :store_list_id
      t.integer :store_id
      t.string :tag
      t.integer :rank
      t.string :comment

      t.timestamps
    end
  end
end
