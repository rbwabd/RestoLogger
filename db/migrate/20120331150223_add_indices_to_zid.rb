class AddIndicesToZid < ActiveRecord::Migration
  def self.up
    add_index :visits, :zid,  :unique => true
    add_index :dish_reviews, :zid,  :unique => true
    add_index :stores, :zid,  :unique => true
    add_index :pictures, :zid,  :unique => true 
    add_index :dishes, :zid,  :unique => true
  end

  def self.down
  end
end
