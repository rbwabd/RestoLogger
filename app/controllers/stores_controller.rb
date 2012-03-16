class StoresController < ApplicationController
  before_filter :authenticate_user!
  #before_filter :authorized_user, :only => :destroy

  def index
    @title = "index_title"
    @stores = Stores.all.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @title = "show_title"
    @button = "new_visit_button"
    @store = Store.find(params[:id])
  end

  def new
    @title = "new_title"
    @store  = Store.new
    @button = "search_button"
    @country = Country.find_by_name("United Kingdom")
    @state = State.find_by_name("London")
    @city = City.find_city("London", "London", "United Kingdom").first
  end
  
  def create

  end

  def onlinesearch
    #city=City.find(params[:city][:id])
    #state=State.find(params[:state][:id])
    #country=Country.find(params[:country][:id])
    #new_name=params[:store][:name]
    #res=Store.store_search(new_name.gsub(' ','+'), city.name.gsub(' ','+'), state.name.gsub(' ','+'), country.name.gsub(' ','+'))
    #p res[:address]
    #p res[:url]
    #p res[:name]  
    #render(:layout => false)
    #http://stackoverflow.com/questions/4766383/rails-3-link-to-to-call-partial-using-jquery-ajax
  end
  
  def destroy
    @store.destroy
    redirect_to root_path, :flash => { :success => "Store deleted!" }
  end
end