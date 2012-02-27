class CreateVisits < ActiveRecord::Migration
  def self.up
    create_table :visits do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :visits, [:user_id, :created_at]
  end

  def self.down
    drop_table :visits
  end
end
