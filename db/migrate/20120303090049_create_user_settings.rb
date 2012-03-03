class CreateUserSettings < ActiveRecord::Migration
  def self.up
    create_table :user_settings do |t|
      t.string :locale
      t.integer :current_city
      t.integer :user_id

      t.timestamps
    end
    add_index :user_settings, :user_id
  end

  def self.down
    drop_table :user_settings
  end
end
