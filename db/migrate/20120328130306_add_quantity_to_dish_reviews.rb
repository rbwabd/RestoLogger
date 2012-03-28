class AddQuantityToDishReviews < ActiveRecord::Migration
  def change
    add_column :dish_reviews, :quantity, :integer

  end
end
