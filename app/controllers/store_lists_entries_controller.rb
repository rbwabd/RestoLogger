class StoreListsController < ApplicationController
  before_filter :decode_id
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def destroy
    @store_list_entry.destroy
    respond_to do |format|
      format.html { redirect_to root_path, :flash => { :success => "Store List Entry deleted!" } }
      format.js 
    end
  end
end


