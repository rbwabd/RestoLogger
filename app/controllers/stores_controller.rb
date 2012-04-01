class StoresController < ApplicationController
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

  def add_menu
    @title = "dishes.add_menu_title"
    @button = "dishes.add_menu_button"
    @dish = Dish.new
    @store = Store.find_by_zid(params[:id])
    ectmp = DishType.find_all_by_store_id(@store.id)
    arraytmp = Array.new
    ectmp.each {|x| arraytmp << x.name}
    @existing_categories = arraytmp.join("\r\n\r\n")
  end

  def submit_menu
    @title = "dishes.confirm_menu_title"
    @button = "dishes.confirm_menu_button"
    @dish = Dish.new
    @store = Store.find_by_zid(params[:id])
    entries_text = params[:entries]
    category = I18n.t('dishes.default_category')
    @entries = Array.new
    entries_text.each_line do |s| 
      # remove newline
      l = s.gsub(/(\r)?\n/, '')
      start = 0
      offset = l.index(';', start)
      if offset.nil?
        if l.strip.size > 0
          category=l
        end
      else
        entry = Array.new
        entry << category
        while !offset.nil?
          item = l[start..offset-1].strip
          entry << item
          start = offset+1
          offset = l.index(';', start)
        end 
        item = l[start..l.size-1].strip
        entry << item
        
        #add dummies
        while entry.size < 5
          entry << ""
        end
        
        #the name and price could include [] signs, between which are some optional comments
        tmpentry = entry[1]
        start = tmpentry.index('[')
        finish = tmpentry.index(']')
        if start and finish
          item = tmpentry[start+1..finish-1]
          entry[1] = tmpentry.gsub(/\[.*\]/,'')
          entry << item
        else
          entry << ""
        end

        tmpentry = entry[2]
        start = tmpentry.index('[')
        finish = tmpentry.index(']')
        if start and finish
          item = tmpentry[start+1..finish-1]
          entry[2] = tmpentry.gsub(/\[.*\]/,'')
          entry << item
        else
          entry << ""
        end
        #put price at 0 if empty
        if entry[2].nil? or entry[2].size == 0
          entry[2] = '0' 
        end          
        #only add entries with a name
        if !(entry[1].nil? or entry[1].size == 0)
          # 2do: need to add error message if name empty
          @entries << entry
        end  
      end      
    end
    render 'confirm_menu'
  end
  
  def save_menu
    store = Store.find_by_zid(params[:id])
    tmphash = Hash.new
    
    # 2do: need to check for cases where entry already exists, using name.downcase to compare downcase
    #validates_uniqueness_of :name, :case_sensitive => false
    #Please note that by default the setting is :case_sensitive => false, so you don't even need to write this option if you haven't changed other ways.
 
    for count in 0..params[:count].to_i-1
      category = params["category"+count.to_s]
      name = params["name"+count.to_s]
      option_description = params["optiondesc"+count.to_s]
      price_comment = params["pricecomment"+count.to_s]
      price = params["price"+count.to_s]
      description = params["description"+count.to_s]
      code = params["code"+count.to_s]
      
      dish = Dish.new({ :store_id => store.id, :name => name, :option_description => option_description, :price_comment => price_comment, :price => price, :description => description, :code => code})
      if !tmphash.has_key?(category)
        tmphash[category] = Array.new
      end
      tmphash[category] << dish
    end  
      
    typeCnt = DishType.count( :conditions => ["store_id = ?", store.id])

    tmphash.each do |cat, dish_array|
      if !dt=DishType.find_by_name_and_store_id(cat, store.id) 
        dt=DishType.new({ :name => cat, :store_id => store.id, :rank => typeCnt })
        if dt.save
          typeCnt+=1
        else
          #2do: add error if save fails
        end
      end          

      if !dt.id.nil?
        dishCnt = Dish.count( :conditions => ["dish_type_id = ?", dt.id])
        dish_array.each do |dish|
          # need to check dish doesn't already exist. check across categories as users may put in wrong category
          if !Dish.where(:name => dish.name, :store_id => store.id).exists?
            dish.dish_type_id = dt.id
            dish.rank = dishCnt
            #2do: need to add error message if save fails
            dish.save
            dishCnt+=1
          end
        end
      end
    end
    redirect_to show_menu_store_path(store.zid), :flash => { :success => (count ? count+1 : 0).to_s+" New Dishes Saved" }
  end

  def edit_menu_order
    @title = "stores.edit_menu_title"
    @button = "stores.save_button"
    @store = Store.find_by_zid(params[:id])
    @dishes = @store.get_menu
  end

  def update_menu_order
    @store = Store.find_by_zid(params[:id])
    store_dishes = @store.dishes
    store_dishes.each do |dish|
      if params["taborder_"+dish.dish_type.id.to_s] != ""
        dish.dish_type.rank=params["taborder_"+dish.dish_type.id.to_s]
        dish.dish_type.save
      end
      if params["dd_"+dish.id.to_s] != ""
        dish.rank=params["dd_"+dish.id.to_s]
        dish.save
      end
    end
    redirect_to show_menu_store_path(@store.zid)
  end

  def destroy
    @store.destroy
    redirect_to root_path, :flash => { :success => "Store deleted!" }
  end
end