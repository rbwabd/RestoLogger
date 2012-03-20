class AddFxcodeToStores < ActiveRecord::Migration
  def change
    add_column :stores, :fxcode, :string

  end
end
