class StoresController < ApplicationController
  before_filter :authenticate_user!
  #before_filter :authorized_user, :only => :destroy
  
  # 2do: this is needed due to Store.all.paginate call (static array - can remove after i take that code out)
  require 'will_paginate/array'
  
  def index
    @title = "stores.index_title"
    @button = "stores.new_visit_button"
    @button2 = "stores.new_dish_button"
    @button3 = "stores.show_menu_button"
    @stores = Store.all.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @title = "stores.show_title"
    @button = "stores.new_visit_button"
    @button2 = "stores.new_dish_button"
    @button3 = "stores.show_menu_button"
    @button4 = "stores.edit_menu_button"
    @store = Store.find(params[:id])
  end

  def new
    @title = "stores.new_title"
    @button = "stores.new_button"
    @store  = Store.new( {:name => params[:name], :address => params[:address]})
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
      redirect_to @store, :flash => { :success => "New Store Saved" }
    else
      @title = "stores.new_title"
      @button = "stores.new_button"
      @store  = Store.new( {:name => params[:store][:name], :address => params[:store][:address]})
      @country=Country.find(params[:country][:id])
      @state=State.find(params[:state][:id])
      @city=City.find(params[:city][:id])
      render 'new'
    end
  end
  
  def search
    @title = "stores.search_title"
    @button = "stores.search_button"
    @store  = Store.new
    @country = Country.find_by_name("United Kingdom")
    @state = State.find_by_name("London")
    @city = City.find_city("London", "London", "United Kingdom").first
    @res=Array.new
  end
  
  def search_results
    #if params[:commit]==I18n.t("stores.search_button") then
    @country=Country.find(params[:country][:id])
    @state=State.find(params[:state][:id])
    @city=City.find(params[:city][:id])
    @title = "stores.new_title"
    @button = "stores.search_button"
    @button2 = "stores.add_as_new_link"
    new_name=params[:store][:name]
    @res=Store.store_search(new_name.gsub(' ','+'), @city.name.gsub(' ','+'), @state.name.gsub(' ','+'), @country.name.gsub(' ','+'))
    # 2do: need to test for when nothing is returned!!!
    # 2do: need to test @res for entries already in DB!!! (i.e. google id = same
    
    @store  = Store.new(:name => new_name)
    render 'search'
    #http://stackoverflow.com/questions/4766383/rails-3-link-to-to-call-partial-using-jquery-ajax
  end
  
  def show_menu
    @title = "stores.show_menu_title"
    @store=Store.find(params[:id])
    store_dishes=@store.dishes.sort! { |a,b| a.dish_type.rank <=> b.dish_type.rank }
    @dishes = Hash.new
    store_dishes.each { |dish|
      if !@dishes.has_key?(dish.dish_type.name)
        @dishes[dish.dish_type.name] = Array.new
      end
      @dishes[dish.dish_type.name] << dish
    }    
  end

  def edit_menu
    @title = "stores.edit_menu_title"
    @button = "stores.save_button"
    @store=Store.find(params[:id])
    store_dishes=@store.dishes
    @dishes = Hash.new
    store_dishes.each { |dish|
      if !@dishes.has_key?(dish.dish_type.name)
        @dishes[dish.dish_type.name] = Array.new
      end
      @dishes[dish.dish_type.name] << dish
    }    
    #http://jqueryui.com/demos/draggable/#sortable
  end

  def update_menu
    p "hello"
    p "hello"
    p "hello"
    p "hello"
    p params
    p "hello"
    p "hello"
    p "hello"
  
    redirect_to root_path
  end

  def destroy
    @store.destroy
    redirect_to root_path, :flash => { :success => "Store deleted!" }
  end
end