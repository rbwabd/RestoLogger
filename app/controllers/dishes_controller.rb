class DishesController < ApplicationController
  before_filter :authenticate_user!
  #before_filter :authorized_user, :only => :destroy
  
  def index
    @title = "dishes.index_title"
    #@dishes = Dish.all.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @title = "dishes.show_title"
    @button = "dishes.new_visit_button"
    @dish = Dish.find(params[:id])
  end

  def add_menu
    @title = "dishes.add_menu_title"
    @button = "dishes.add_menu_button"
    @dish = Dish.new
    @storeid = params[:id]
  end

  def submit_menu
    @title = "dishes.confirm_menu_title"
    @button = "dishes.confirm_menu_button"
    @dish  = Dish.new
    @storeid = params[:storeid]
    entries_text = params[:entries]
    category = I18n.t('dishes.default_category')
    @entries = Array.new
    entries_text.each_line {|s| 
      # remove newline
      l = s.gsub(/(\r)?\n/, '')
      start = 0
      offset = l.index(';', start)
      if offset.nil?
        category=l
      else
        entry = Array.new
        entry << category
        while !offset.nil?
          item = l[start..offset-1].strip
          entry << item
          start = offset+1
          offset = l.index(';', start)
        end 
        item = l[start..l.size].strip
        entry << item
        
        #add dummies
        while entry.size < 5
          entry << ""
        end
        
        #the name and price could include [] signs, between which are some optional comments
        tmpentry=entry[1]
        start=tmpentry.index('[')
        finish=tmpentry.index(']')
        if start and finish
          item= tmpentry[start+1..finish-1]
          entry[1]=tmpentry.gsub(/\[.*\]/,'')
          entry << item
        else
          entry << ""
        end

        tmpentry=entry[2]
        start=tmpentry.index('[')
        finish=tmpentry.index(']')
        if start and finish
          item= tmpentry[start+1..finish-1]
          entry[2]=tmpentry.gsub(/\[.*\]/,'')
          entry << item
        else
          entry << ""
        end
        #put price at 0
        if !(entry[2].nil? or entry[2].size=0)
          @entry[2] = '0' 
        end          
        #only add entries with a name
        if !(entry[1].nil? or entry[1].size=0)
          @entries << entry
        end  
      end      
    }
    render 'confirm_menu'
  end
  
  def save_menu
    store = Store.find(params[:storeid])
    if store.dishes.size > 0
      rank = store.dishes.maximum("rank")+1
    else
      rank = 0
    end
    
    # 2do: need to add logic to store store_type rank (maybe not just leave uninitialized on first run...)
    
    # 2do: need to check for cases where entry already exists, using name.downcase to compare downcase

    count = 0
    maxcount = params[:count].to_i
    while count < maxcount
      category = params["category"+count.to_s]
      name = params["name"+count.to_s]
      option_description = params["optiondesc"+count.to_s]
      price_comment =params["pricecomment"+count.to_s]
      price = params["price"+count.to_s]
      description = params["description"+count.to_s]
      code = params["code"+count.to_s]
      
      dish = Dish.new({ :store_id => store.id, :name => name, :option_description => option_description, :price_comment => price_comment, :price => price, :description => description, :code => code, :rank => rank })
      dt = DishType.find_or_create_by_name_and_store_id(category, store.id);      
      dish.dish_type_id = dt.id
      
      if dish.save
        rank += 1;
      else  
        # 2do: need to write exception case - just keep the items that are not saved and redisplay them to user
      end
      count += 1
    end
    redirect_to show_menu_path({ :id => store.id }), :flash => { :success => count.to_s+" New Dishes Saved" }
  end
  
  def destroy
    @dish.destroy
    redirect_to root_path, :flash => { :success => "Dish deleted!" }
  end
end