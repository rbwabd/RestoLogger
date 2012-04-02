class AddUserToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :user_id, :integer

  end
end
