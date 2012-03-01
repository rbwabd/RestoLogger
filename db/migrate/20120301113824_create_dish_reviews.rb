class CreateDishReviews < ActiveRecord::Migration
  def self.up
    create_table :dish_reviews do |t|
      t.integer :rating
      t.string :tagline
      t.string :review
      t.integer :dish_id
      t.integer :user_id
      t.integer :visit_id

      t.timestamps
    end
    
    add_index :dish_reviews, [:dish_id, :user_id, :visit_id]
  end

  def self.down
    drop_table :dish_reviews
  end
end
