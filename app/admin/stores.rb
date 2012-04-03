ActiveAdmin.register Store do
  index do
    column :id
    column "Store Name", :name
    column "Address", :address
    column "Post Code", :postcode
    column :user_id
    default_actions
  end
end
