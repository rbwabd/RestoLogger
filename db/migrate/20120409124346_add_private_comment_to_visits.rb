class AddPrivateCommentToVisits < ActiveRecord::Migration
  def change
    add_column :visits, :private_comment, :string

  end
end
