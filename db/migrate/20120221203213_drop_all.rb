class DropAll < ActiveRecord::Migration
  def self.up
    drop_table :microposts
		drop_table :users
		drop_table :relationships
		drop_table :authentications
  end

  def self.down
    
  end
end
