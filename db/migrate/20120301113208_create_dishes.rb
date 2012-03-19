class CreateDishes < ActiveRecord::Migration
  def self.up
    create_table :dishes do |t|
      t.string :name
      t.string :alt_name
      t.integer :dish_type_id
      t.string :code
      t.string :description
      
      t.timestamps
    end
    add_index :dishes, [:dish_type_id]
  end
 
  def self.down
    drop_table :dishes
  end
end
