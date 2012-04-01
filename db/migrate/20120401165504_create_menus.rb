class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.integer :store_id
      t.string :currency

      t.timestamps
    end
  end
end
