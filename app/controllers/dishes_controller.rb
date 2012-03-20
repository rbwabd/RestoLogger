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
    category = ""
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
        @entries << entry
      end
    }
=begin    
#need to add error checking on the fields
    @entries.each { |entry|    
      if name.nil? or name.size=0 
        #need to raise some kind of error message
      else
        if category.nil? or category.size=0 
          category=I18n.t('dishes.default_category')
        end     
        if price.nil? or price.size=0 
          price='0'
        end     
      end
    }
=end    
    
    render 'confirm_menu'
  end
  
  def save_menu
    store = Store.find(params[:storeid])
    if store.dishes.size > 0
      rank = store.dishes.maximum("rank")+1
    else
      rank = 0
    end
    
    count = 0
    maxcount = params[:count].to_i
    while count < maxcount
      category = params["category"+count.to_s]
      name = params["name"+count.to_s]
      price = params["price"+count.to_s]
      description = params["description"+count.to_s]
      code = params["code"+count.to_s]
      
      dish = Dish.new({ :store_id => store.id, :name => name, :price => price, :description => description, :code => code, :rank => rank })
      dt = DishType.find_or_create_by_name_and_store_id(category, store.id);      
      dish.dish_type_id = dt.id
      
      if dish.save
        rank += 1;
      else  
        # need to write exception case - just keep the items that are not saved and redisplay them to user
      end
      count += 1
    end
    redirect_to store, :flash => { :success => count.to_s+" New Dishes Saved" }
  end
  
  def destroy
    @dish.destroy
    redirect_to root_path, :flash => { :success => "Dish deleted!" }
  end
end