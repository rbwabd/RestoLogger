class AddDescriptionToPictures < ActiveRecord::Migration
  def self.up
    add_column :pictures, :description, :string
  end

  def self.down
    remove_column :pictures, :description
  end
end
