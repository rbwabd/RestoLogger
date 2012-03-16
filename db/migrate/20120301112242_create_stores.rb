class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :name
      t.string :shortname
      t.string :email
      t.string :phone
      t.string :phone2
      t.string :address
      t.string :postcode
      t.integer :city_id
      t.integer :chain_id
      t.integer :store_type_id
      t.string :keyword
      
      t.timestamps
    end
    
    add_index :stores, [:city_id, :chain_id, :store_type_id]
  end

  def self.down
    drop_table :stores
  end
end
