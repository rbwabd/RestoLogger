class AddImageToPictures < ActiveRecord::Migration
  def self.up
    add_column :pictures, :image, :string
  end

  def self.down
    remove_column :pictures, :image
  end
end
