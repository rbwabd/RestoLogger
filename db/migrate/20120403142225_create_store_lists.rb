class CreateStoreLists < ActiveRecord::Migration
  def change
    create_table :store_lists do |t|
      t.integer :user_id
      t.string :name

      t.timestamps
    end
  end
end
