class StoreListsController < ApplicationController
  before_filter :decode_id
  before_filter :authenticate_user!
  load_and_authorize_resource :except => :show

  #def index
  #  @title = "store_lists.index_title"
  #end

  def show
    authorize! :show, StoreList
    if params[:first]
      @store_list = current_user.store_lists.first
    else
      @store_list = StoreList.find(params[:id])
    end
    @title = "empty"
    @store_lists = StoreList.where("user_id = ?", current_user.id).order("name asc")
  end

  def new 
    @title = "store_lists.new_title"
    @button = "create_button"
    if params[:add_store_id]
      @add_store_id = params[:add_store_id]
    end
  end

  def create
    @store_list.name = params[:store_list][:name]
    @store_list.user_id = current_user.id

    if params[:add_store_id]
    
    p "Test Output-------------"
    p "Test Output-------------"
    p "Test Output-------------"
    p "Test Output-------------"
    p params[:add_store_id]
    p "Test Output-------------"
    p "Test Output-------------"
    p "Test Output-------------"
    p "Test Output-------------"
    
      @store_list.stores << Store.find(Hid.dec(params[:add_store_id]))
    end
    if @store_list.save
      redirect_to store_list_path(@store_list) 
    else
      #2do:
    end
  end
    
  def edit
    @title = "store_lists.edit_title"
    @button = "update_button"
  end

  def update
    @store_list.name = params[:store_list][:name]
    if @store_list.save
      redirect_to store_lists_path
    else
      #2do:
    end
  end
  
  def destroy
    @store_list.destroy
    redirect_to root_path, :flash => { :success => "Store List deleted!" }
  end

  def add_item
    sle = StoreListEntry.new
    sle.store_id = Hid.dec(params[:store_id])
    sle.rank = @store_list.store_list_entries.size + 1
    sle.store_list_id = @store_list.id;
    if sle.save
      redirect_to store_list_path(Hid.enc(@store_list.id))
      #respond_to do |format|
      #  format.html 
      #  format.js 
      #end
    else
      #2do:
    end  
  end
end


