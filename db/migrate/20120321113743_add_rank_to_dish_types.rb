class AddRankToDishTypes < ActiveRecord::Migration
  def change
    add_column :dish_types, :rank, :integer

  end
end
