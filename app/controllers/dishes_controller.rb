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
    @dish  = Dish.new
  end

  def submit_menu
    @title = "dishes.confirm_menu_title"
    @button = "dishes.confirm_menu_button"
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
    render 'confirm_menu'
  end
  
  def save_menu
=begin    
    if @dish.save
      redirect_to @dish, :flash => { :success => "New Dish Saved" }
    else
      @title = "dishes.new_title"
      @button = "dishes.new_button"
      @dish  = Dish.new
      render 'new'
    end
=end
  end
  
  def destroy
    @dish.destroy
    redirect_to root_path, :flash => { :success => "Dish deleted!" }
  end
end