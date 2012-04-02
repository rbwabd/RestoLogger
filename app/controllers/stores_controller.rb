class StoresController < ApplicationController
  before_filter :decode_id
  #before_filter :authenticate_user!
  #before_filter :authorized_user, :only => :destroy
    
  # 2do: this is needed due to Store.all.paginate call that is on an array as opposed to active record call somehow
  require 'will_paginate/array'
  
  def index
    @button = "stores.new_visit_button"
    @button2 = "stores.show_menu_button"
    @stores = Store.all.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @button = "stores.new_visit_button"
    @button2 = "stores.show_menu_button"
    @store = Store.find(params[:id])
  end
=begin
  def new
    @title = "stores.new_title"
    @button = "stores.new_button"
    @store = Store.new( {:name => params[:name], :address => params[:address]})
    @country = Country.find(params[:param][:country][:id])
    @state = State.find(params[:param][:state][:id])
    @city = City.find(params[:param][:city][:id])
  end
=end
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
    @store.menu = Menu.new( :currency => "GBP" );
    
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
    @button = "search_button"
    @button2 = "stores.add_as_new_store_button"
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
  
  def destroy
    @store.destroy
    redirect_to root_path, :flash => { :success => "Store deleted!" }
  end
end