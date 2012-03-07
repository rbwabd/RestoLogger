class AddVisitUserIdToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :user_id, :integer

    add_column :pictures, :visit_id, :integer

  end
end
