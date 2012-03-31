class StoresController < ApplicationController
  before_filter :authenticate_user!
  #before_filter :authorized_user, :only => :destroy
  
  # 2do: this is needed due to Store.all.paginate call that is on an array as opposed to active record call somehow
  require 'will_paginate/array'
  
  def index
    @button = "stores.new_visit_button"
    @button2 = "stores.show_menu_button"
    @stores = Store.all.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @title = "stores.show_title"
    @button = "stores.new_visit_button"
    @button2 = "stores.show_menu_button"
    @store = Store.find_by_zid(params[:id])
  end

  def new
    @title = "stores.new_title"
    @button = "stores.new_button"
    @store = Store.new( {:name => params[:name], :address => params[:address]})
    @country = Country.find(params[:param][:country][:id])
    @state = State.find(params[:param][:state][:id])
    @city = City.find(params[:param][:city][:id])
  end

  def create
    @store = Store.new
    @store.city_id = params[:city][:id]
    @store.name = params[:store][:name]
    @store.address = params[:store][:address]
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
      @country = Country.find(params[:country][:id])
      @state = State.find(params[:state][:id])
      @city = City.find(params[:city][:id])
      render 'new'
    end
  end
  
  def search
    @button = "stores.search_button"
    @store  = Store.new
    @country = Country.find_by_name("United Kingdom")
    @state = State.find_by_name("London")
    @city = City.find_city("London", "London", "United Kingdom").first
    @res = Array.new
  end
  
  def search_results
    @title = "stores.new_title"
    @button = "stores.search_button"
    @button2 = "stores.add_as_new_link"
    #if params[:commit]==I18n.t("stores.search_button") then
    @country = Country.find(params[:country][:id])
    @state = State.find(params[:state][:id])
    @city = City.find(params[:city][:id])
    new_name = params[:store_search_name]
    @res = Store.store_search(new_name.gsub(' ','+'), @city.name.gsub(' ','+'), @state.name.gsub(' ','+'), @country.name.gsub(' ','+'))
    # 2do: need to test for when nothing is returned!!!
    # 2do: need to test @res for entries already in DB!!! (i.e. google id = same
    
    @store  = Store.new(:name => new_name)
    render 'search'
  end
  
  def show_menu
    @title = "stores.show_menu_title"
    @button = "stores.new_dish_button"
    @button2 = "stores.edit_menu_button"
    @store = Store.find_by_zid(params[:id])
    @dishes = @store.get_menu
  end

  def edit_menu
    @title = "stores.edit_menu_title"
    @button = "stores.save_button"
    @store = Store.find_by_zid(params[:id])
    @dishes = @store.get_menu
    session[:store_id] = params[:id]
  end

  def update_menu
    @store = Store.find_by_zid(session[:store_id])
    store_dishes = @store.dishes
    store_dishes.each { |dish|
      if params["taborder_"+dish.dish_type.id.to_s] != ""
        dish.dish_type.rank=params["taborder_"+dish.dish_type.id.to_s]
        dish.dish_type.save
      end
      if params["dd_"+dish.id.to_s] != ""
        dish.rank=params["dd_"+dish.id.to_s]
        dish.save
      end
    }
    redirect_to show_menu_path(:id => @store.zid)
  end

  def destroy
    @store.destroy
    redirect_to root_path, :flash => { :success => "Store deleted!" }
  end
end