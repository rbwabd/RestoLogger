class AddSpendAndPerimatedToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :spend, :float

    add_column :visits, :perimated, :integer

  end
end
