class StoreListsController < ApplicationController
  before_filter :decode_id
  before_filter :authenticate_user!
  load_and_authorize_resource 

  def index
    @title = "store_lists.index_title"
  end

  def show
  end

  def new 
    @title = "store_lists.new_title"
    @button = "store_lists.new_button"
  end
  
  def create
    @store_list.name = params[:store_list][:name]
    @store_list.user_id = current_user.id
    if @store_list.save
      redirect_to store_lists_path
    else
      #2do:
    end
  end
  
end


