class AddZidToDishReviews < ActiveRecord::Migration
  def change
    add_column :dish_reviews, :zid, :string

  end
end
