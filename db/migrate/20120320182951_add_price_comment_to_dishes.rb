class AddPriceCommentToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :price_comment, :string
    add_column :dishes, :option_description, :string

  end
end
