class AddRankToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :rank, :integer

  end
end
