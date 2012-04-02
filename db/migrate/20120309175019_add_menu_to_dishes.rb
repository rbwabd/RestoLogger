class AddStoreToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :menu_id, :integer

  end
end
