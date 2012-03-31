class AddIndicesToZidInUsers < ActiveRecord::Migration
  def self.up
    add_index :users, :zid,  :unique => true
  end

  def self.down
  end
end
