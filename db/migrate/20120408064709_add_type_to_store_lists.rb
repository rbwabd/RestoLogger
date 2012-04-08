class AddTypeToStoreLists < ActiveRecord::Migration
  def change
    add_column :store_lists, :type, :string

  end
end
