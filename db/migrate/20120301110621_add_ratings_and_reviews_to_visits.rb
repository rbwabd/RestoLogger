class AddRatingsAndReviewsToVisits < ActiveRecord::Migration
  def self.up
    add_column :visits, :overall_rating, :integer
    add_column :visits, :service_rating, :integer
    add_column :visits, :speed_rating, :integer
    add_column :visits, :mood_rating, :integer
    add_column :visits, :tagline, :string
    add_column :visits, :review, :string
    add_column :visits, :guest_number, :integer
  end

  def self.down
    remove_column :visits, :guest_number
    remove_column :visits, :review
    remove_column :visits, :tagline
    remove_column :visits, :mood_rating
    remove_column :visits, :speed_rating
    remove_column :visits, :service_rating
    remove_column :visits, :overall_rating
  end
end
