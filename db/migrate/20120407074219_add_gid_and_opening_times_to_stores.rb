class AddGidAndOpeningTimesToStores < ActiveRecord::Migration
  def change
    add_column :stores, :opening_times, :string
    add_column :stores, :gid, :string
  end
end
