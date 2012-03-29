class AddRankToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :rank, :integer

  end
end
