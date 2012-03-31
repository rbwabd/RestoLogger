class AddZidToStores < ActiveRecord::Migration
  def change
    add_column :stores, :zid, :string

  end
end
