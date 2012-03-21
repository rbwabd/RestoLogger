class AddPicUrlToDishes < ActiveRecord::Migration
  def change
    add_column :dishes, :pic_url, :string

  end
end
