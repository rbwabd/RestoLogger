class CreateDishes < ActiveRecord::Migration
  def self.up
    create_table :dishes do |t|
      t.string :name
      t.string :alt_name
      t.integer :category
      t.integer :dish_type_id
      t.string :keyword
      
      t.timestamps
    end
    add_index :dishes, [:dish_type_id]
  end
 
  def self.down
    drop_table :dishes
  end
end
