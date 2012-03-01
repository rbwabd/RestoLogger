class CreateStoreTypes < ActiveRecord::Migration
  def self.up
    create_table :store_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :store_types
  end
end
