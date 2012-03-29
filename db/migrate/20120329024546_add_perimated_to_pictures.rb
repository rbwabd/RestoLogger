class AddPerimatedToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :perimated, :integer

  end
end
