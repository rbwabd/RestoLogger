class AddRankToDishReviews < ActiveRecord::Migration
  def change
    add_column :dish_reviews, :rank, :integer

  end
end
