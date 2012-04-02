class ChangeReviewTypeToText < ActiveRecord::Migration
  def change
    change_column :visits, :review, :text
    change_column :dish_reviews, :review, :text
  end
end
