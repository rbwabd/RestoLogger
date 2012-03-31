class AddZidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :zid, :string
  end
end
