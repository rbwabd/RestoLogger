  class AddIndicesToVisits < ActiveRecord::Migration
  def self.up
    add_column :visits, :city_id, :integer
    add_column :visits, :store_id, :integer
    add_column :visits, :visit_date, :date
    add_index :visits, [:city_id, :store_id]
  end

  def self.down
    remove_column :visits, :visit_date
    remove_column :visits, :store_id
    remove_column :visits, :city_id
  end
end
