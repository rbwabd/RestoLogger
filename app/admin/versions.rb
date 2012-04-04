ActiveAdmin.register Version do
  index do
    column "User" do |a|
      User.find(a.whodunnit).name
    end
    column :item_type
    column :item_id
    column :event
    column :object
    default_actions
  end


end 