class AddMenuToDishTypes < ActiveRecord::Migration
  def change
    add_column :dish_types, :menu_id, :integer

  end
end
