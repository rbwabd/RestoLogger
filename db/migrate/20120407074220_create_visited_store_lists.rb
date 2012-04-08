class CreateVisitedStoreLists < ActiveRecord::Migration
  def change
    create_table :visited_store_lists do |t|
      t.integer :user_id

      t.timestamps
    end
  end
end
