class AddVisibilityMaskToStoreLists < ActiveRecord::Migration
  def change
    add_column :store_lists, :visibility_mask, :integer

  end
end
