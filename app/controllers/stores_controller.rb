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
    @store  = Store.new( {:name => params[:name], :address => params[:address]})
    @button = "new_button"
    @country=Country.find(params[:param][:country][:id])
    @state=State.find(params[:param][:state][:id])
    @city=City.find(params[:param][:city][:id])
  end

  def create
    @store = Store.new
    @store.city_id=params[:city][:id]
    @store.name=params[:store][:name]
    @store.address=params[:store][:address]
    if !params[:store_type]["Category1"].empty? then
      @store.store_type_relationships.build({:store_type_id =>params[:store_type]["Category1"]})
    end  
    if !params[:store_type]["Category2"].empty? and params[:store_type]["Category2"] != params[:store_type]["Category1"] then
      @store.store_type_relationships.build({:store_type_id =>params[:store_type]["Category2"]})
    end  
    if !params[:store_type]["Category3"].empty? and params[:store_type]["Category3"] != params[:store_type]["Category1"] and params[:store_type]["Category3"] != params[:store_type]["Category2"] then
      @store.store_type_relationships.build({:store_type_id =>params[:store_type]["Category3"]})
    end
    if @store.save
      @title = "new_title"
      redirect_to @store, :flash => { :success => "New Store Saved" }
    else
      @title = "new_title"
      @store  = Store.new( {:name => params[:store][:name], :address => params[:store][:address]})
      @button = "new_button"
      @country=Country.find(params[:country][:id])
      @state=State.find(params[:state][:id])
      @city=City.find(params[:city][:id])
      render 'new'
    end
  end
  
  def search
    @title = "new_title"
    @store  = Store.new
    @button = "search_button"
    @country = Country.find_by_name("United Kingdom")
    @state = State.find_by_name("London")
    @city = City.find_city("London", "London", "United Kingdom").first
  end
  
  def search_results
    #if params[:commit]==I18n.t("search_button") then
    @country=Country.find(params[:country][:id])
    @state=State.find(params[:state][:id])
    @city=City.find(params[:city][:id])
    @title = "new_title"
    @button = "search_button"
    @button2 = "new_button"
    new_name=params[:store][:name]
    @res=Store.store_search(new_name.gsub(' ','+'), @city.name.gsub(' ','+'), @state.name.gsub(' ','+'), @country.name.gsub(' ','+'))
    #p @res[:address]
    #p @res[:url]
    #p @res[:name]
    #p params
    @store  = Store.new(:name => new_name)
    render 'search'
    #else
    #end
    #http://stackoverflow.com/questions/4766383/rails-3-link-to-to-call-partial-using-jquery-ajax
  end

  def destroy
    @store.destroy
    redirect_to root_path, :flash => { :success => "Store deleted!" }
  end
end