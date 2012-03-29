class AddPerimatedToDishReview < ActiveRecord::Migration
  def change
    add_column :dish_reviews, :perimated, :integer

  end
end
