class AddVisibilityMaskToDishReviews < ActiveRecord::Migration
  def change
    add_column :dish_reviews, :visibility_mask, :integer

  end
end
