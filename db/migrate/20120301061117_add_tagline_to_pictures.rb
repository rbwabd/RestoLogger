class AddTaglineToPictures < ActiveRecord::Migration
  def self.up
    add_column :pictures, :tagline, :string
  end

  def self.down
    remove_column :pictures, :tagline
  end
end
