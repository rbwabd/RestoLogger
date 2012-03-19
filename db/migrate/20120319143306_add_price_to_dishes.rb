class AddPriceToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :price, :float

  end
end
