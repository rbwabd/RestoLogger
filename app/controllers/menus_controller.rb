class MenusController < ApplicationController
  before_filter :decode_id
  before_filter :authenticate_user!
  #before_filter :authorized_user, :only => :destroy
    
  def show
    @title = "menus.show_menu_title"
    @button = "menus.new_dish_button"
    @button2 = "menus.edit_menu_button"
    @button3 = "menus.return_to_store_button"
    @store = Store.find(params[:id])
    @dishes = @store.menu.get_dish_hash
  end

  def add
    @title = "menus.add_menu_title"
    @button = "add_button"
    @dish = Dish.new
    @store = Store.find(params[:id])
    ectmp = DishType.find_all_by_store_id(@store.id)
    arraytmp = Array.new
    ectmp.each {|x| arraytmp << x.name}
    @existing_categories = arraytmp.join("\r\n\r\n")
  end

  def confirm
    @title = "menus.confirm_menu_title"
    @button = "confirm_button"
    @dish = Dish.new
    @store = Store.find(params[:id])
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
  
  def save
    store = Store.find(params[:id])
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
      
      dish = Dish.new({ :menu_id => store.menu.id, :name => name, :option_description => option_description, :price_comment => price_comment, :price => price, :description => description, :code => code})
      if !tmphash.has_key?(category)
        tmphash[category] = Array.new
      end
      tmphash[category] << dish
    end  
      
    typeCnt = DishType.count( :conditions => ["menu_id = ?", store.menu.id])

    tmphash.each do |cat, dish_array|
      if !dt=DishType.find_by_name_and_menu_id(cat, store.menu.id) 
        dt=DishType.new({ :name => cat, :menu_id => store.menu.id, :rank => typeCnt })
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
          if !Dish.where(:name => dish.name, :menu_id => store.menu.id).exists?
            dish.dish_type_id = dt.id
            dish.rank = dishCnt
            #2do: need to add error message if save fails
            dish.save
            dishCnt+=1
          end
        end
      end
    end
    redirect_to show_menu_store_path(store), :flash => { :success => (count ? count+1 : 0).to_s+" New Dishes Saved" }
  end

  def edit_order
    @title = "menus.edit_menu_title"
    @button = "save_button"
    @store = Store.find(params[:id])
    @dishes = @store.menu.get_dish_hash
  end

  def update_order
    @store = Store.find(params[:id])
    store_dishes = @store.menu.dishes
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
    redirect_to show_menu_store_path(@store)
  end

  private
    def authorized_user
      @visit = current_user.visits.find(params[:id])
      redirect_to root_path if @visit.nil?
    end
	end