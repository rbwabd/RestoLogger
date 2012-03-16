class StoresController < ApplicationController
  before_filter :authenticate_user!
  #before_filter :authorized_user, :only => :destroy

  def index
    @title = "index_title"
    @stores = Stores.all.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @title = "show_title"
    @store = Store.find(params[:id])
  end

  def new
    @title = "new_title"
    @store  = Store.new
    @button = "new_visit_button"
    @country = Country.find_by_name("United Kingdom")
    @state = State.find_by_name("London")
    city = City.find_city("London", "London", "United Kingdom")
  end
  
  def create
    @visit=Visit.new
  end

  def destroy
    @store.destroy
    redirect_to root_path, :flash => { :success => "Store deleted!" }
  end
end