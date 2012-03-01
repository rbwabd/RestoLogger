class AddFirstlastnameAndBdateAndContactAndGenderToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birth_date, :date
    add_column :users, :phone, :string
    add_column :users, :phone2, :string
    add_column :users, :address, :string
    add_column :users, :gender, :integer
  end

  def self.down
    remove_column :users, :gender
    remove_column :users, :address
    remove_column :users, :phone2
    remove_column :users, :phone
    remove_column :users, :birth_date
    remove_column :users, :last_name
    remove_column :users, :first_name
  end
end
