class VisitsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user, :only => :destroy

  helper_method :sort_column, :sort_direction

  require 'will_paginate/array'

  def index
    @title = "visits.index_title"
    @visits = Array.new
    @current_user.visits.each do |v|
      entry = Hash.new
      entry["date"] = v.visit_date.to_s ? v.visit_date : Date.new(3000,1,1) #hack to allow sort
      entry[:visit_id] = v.id
      entry["store_name"] = v.store.name
      entry[:store_id] = v.store.id
      entry["guest_number"] = v.guest_number.to_s  #to_s is to avoid sort issues with nil
      entry["dish_nb"] = v.dish_reviews.size
      entry["overall_rating"] = v.overall_rating.to_s
      @visits << entry
    end
    @visits = @visits.sort_by{ |a| a[ params[:sort] ? params[:sort].to_s : "date".to_s ] }
    if params[:direction].nil? || params[:direction] == "desc"
      @visits.reverse!
    end
    @visits = @visits.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @title = "visits.show_title"
    @visit = Visit.find(params[:id])
    @store = Store.find(@visit.store_id)
    @city = City.find(@visit.city_id)
  end

  def new
    @title = "visits.new_title"
    @button = "visits.edit_button"
    @visit = Visit.new
    @store = Store.find(params[:id])
    @dishes = @store.get_menu
    # if a session cart already existed for same store we keep it otherwise put in new one
    if !(session[:store_id] and session[:store_id].to_i==@store.id and session[:cart])
      session[:store_id] = params[:id]
      session[:cart] = Cart.new
    end
  end
  
  def create
    store = Store.find(session[:store_id])
    visit = Visit.new
    visit.user_id = current_user.id
    visit.store_id = store.id
    visit.city_id = store.city_id
    #2do: not sure storing city_id in both visit and store is optimal...
    visit.visit_date = params[:visit][:visit_date]
    #2do: need to check again that date not in future or too far past (do it in model.rb)
    need_confirmation = false
    
    for ci in session[:cart].cart_items
      if ci.dish_id < 0
        need_confirmation = true
        # dish not already in DB
        # 2do: populate an array to be displayed to user for confirmation
      else      
        dreview = DishReview.new
        dreview.user_id = current_user.id
        dreview.dish_id = ci.dish_id
        dreview.quantity = ci.quantity
        visit.dish_reviews << dreview
      end
    end
    
    if need_confirmation
      #2do: display a confirmation screen for new dishes only
    else  
      if visit.save
        session[:cart] = nil
        redirect_to edit_visit_path(visit), :flash => { :success => "Visit created!" }
      else
        #2do: error messages
      end
    end
  end

  def edit
    @title = "visits.edit_title"
    @button = "visits.edit_button"
    @visit  = Visit.find(params[:id])
    @store = @visit.store
  end

  def update
    visit  = Visit.find(params[:id])
    
    visit.user_id = current_user.id
    visit.overall_rating = params[:visit][:overall_rating]
    visit.service_rating = params[:visit][:service_rating]
    visit.speed_rating = params[:visit][:speed_rating]
    visit.mood_rating = params[:visit][:modd_rating]
    visit.tagline = params[:visit][:tagline]
    visit.review = params[:visit][:review]
    visit.guest_number = params[:visit][:guest_number]
    #2do: need to check again that date not in future or too far past (do it in model.rb)
    visit.visit_date = params[:visit][:visit_date]

    visit.dish_reviews.each_with_index do | dr, i |
      if params['dr'+i.to_s]
        params['dr'+i.to_s].each do | pic |
          tmppic=Picture.new
          tmppic.image=pic
          dr.pictures << tmppic    
        end
      end
    end
	     
    if visit.save
      redirect_to visit_path(visit), :flash => { :success => "Visit updated!" }
    else
      @feed_items = []
      render 'pages/home'
    end    
  end
  
  def change_cart
    if params[:delall]
      session[:cart] = Cart.new
    elsif params[:del]
      session[:cart].remove_dish(params[:dish_name])
    else
      if !dish=Dish.find(params[:dish_id]) and params[:dish_name] and params[:dish_name].size > 0 
        #new dish, to be added to DB
        session[:cart].add_dish(params[:dish_name], 0, -1)
      else
        session[:cart].add_dish(dish.name, dish.price, dish.id)
      end
    end
    respond_to do |format|
      format.html { render :partial => "cart", :object => session[:cart] }
      format.js 
    end
    # 2do: use number_to_currency(cart_item.price) in views
  end

  def destroy
    @visit.destroy
    redirect_to root_path, :flash => { :success => "Visit deleted!" }
  end
  
  private
    def authorized_user
      @visit = current_user.visits.find_by_id(params[:id])
      redirect_to root_path if @visit.nil?
    end
	
    def sort_column
      Visit.column_names.include?(params[:sort]) ? params[:sort] : "visit_date"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end