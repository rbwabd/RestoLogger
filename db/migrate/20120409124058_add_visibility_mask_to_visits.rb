class AddVisibilityMaskToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :visibility_mask, :integer

  end
end
