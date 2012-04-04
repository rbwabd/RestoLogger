ActiveAdmin.register Audit do
  index do
    column "User" do |a|
      User.find(a.user_id).name
    end
    column :auditable_type
    column :auditable_id
    column :action
    default_actions
  end


end 