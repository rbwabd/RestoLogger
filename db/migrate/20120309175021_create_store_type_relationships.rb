class CreateStoreTypeRelationships < ActiveRecord::Migration
  def self.up
    create_table :store_type_relationships do |t|
      t.integer :store_id
      t.integer :store_type_id

      t.timestamps
    end
    add_index :store_type_relationships, :store_id
    add_index :store_type_relationships, :store_type_id
    add_index :store_type_relationships, [:store_id, :store_type_id], :unique => true
  end

  def self.down
    drop_table :store_type_relationships
  end
end
