class AddUrlToPictures < ActiveRecord::Migration
  def self.up
    add_column :pictures, :url, :string
  end

  def self.down
    remove_column :pictures, :url
  end
end
