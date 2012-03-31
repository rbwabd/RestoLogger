class AddZidToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :zid, :string

  end
end
