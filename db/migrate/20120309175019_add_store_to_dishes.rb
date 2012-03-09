class AddStoreToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :store_id, :integer

  end
end
