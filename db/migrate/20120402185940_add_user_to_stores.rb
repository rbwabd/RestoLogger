class AddUserToStores < ActiveRecord::Migration
  def change
    add_column :stores, :user_id, :integer

  end
end
