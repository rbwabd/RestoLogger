class CreateProfilePictures < ActiveRecord::Migration
  def change
    create_table :profile_pictures do |t|
      t.string :filename
      t.string :image
      t.string :url
      t.integer :user_id

      t.timestamps
    end
  end
end
