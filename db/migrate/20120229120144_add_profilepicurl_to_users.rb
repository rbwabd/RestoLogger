class AddProfilepicurlToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :profilepicurl, :string
  end

  def self.down
    remove_column :users, :profilepicurl
  end
end
