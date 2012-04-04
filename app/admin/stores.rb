ActiveAdmin.register Store do
  index do
    column :id
    column "Store Name", :name
    column "Address", :address
    column "Post Code", :postcode
    column :user_id
    column "Actions" do |store|
      link_to("View", admin_store_path(store.id)) + " " +
      link_to("Edit", edit_admin_store_path(store.id)) + " " +
      link_to("Delete", admin_store_path(store.id), :method => :destroy)
    end
  end
end
