class AddVoteCountToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :vote_count, :integer

  end
end
