class AddStoreToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :store_id, :integer

  end
end
