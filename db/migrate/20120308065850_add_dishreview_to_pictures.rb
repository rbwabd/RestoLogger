class AddDishreviewToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :dish_review_id, :integer

  end
end
