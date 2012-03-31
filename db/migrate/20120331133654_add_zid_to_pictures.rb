class AddZidToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :zid, :string

  end
end
