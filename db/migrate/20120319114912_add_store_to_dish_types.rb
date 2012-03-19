class AddStoreToDishTypes < ActiveRecord::Migration
  def change
    add_column :dish_types, :store_id, :integer

  end
end
