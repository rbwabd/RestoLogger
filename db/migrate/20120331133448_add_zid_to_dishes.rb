class AddZidToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :zid, :string

  end
end
