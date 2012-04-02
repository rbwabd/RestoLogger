class VisitsController < ApplicationController
  before_filter :decode_id
  before_filter :authenticate_user!
  load_and_authorize_resource :except => :change_cart

  helper_method :sort_column, :sort_direction
  
  include ActionView::Helpers::TextHelper
  require 'will_paginate/array'
  
  def index
    #2do: implement a sortable table that doesn't require building an ad-hoc array
    @visitslist = Array.new
    @visits.each do |v|
      entry = Hash.new
      entry["date"] = v.visit_date ? v.visit_date : Date.new(3000,1,1) #hack to allow sort
      entry[:visit_id] = Hid.enc(v.id)
      entry["store_name"] = v.store.name
      entry[:store_id] = Hid.enc(v.store.id)
      entry["guest_number"] = v.guest_number.to_s  #to_s is to avoid sort issues with nil
      entry["dish_nb"] = v.dish_reviews.size
      entry["overall_rating"] = v.overall_rating.to_s
      @visitslist << entry
    end
    @visitslist = @visitslist.sort_by{ |a| a[ params[:sort] ? params[:sort].to_s : "date".to_s ] }
    if params[:direction].nil? || params[:direction] == "desc"
      @visitslist.reverse!
    end
    @visitslist = @visitslist.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @title = "visits.show_title"
    @button = "visits.edit_button"
    @store = Store.find(@visit.store_id)
    @city = City.find(@visit.city_id)
  end

  def new
    @title = "visits.new_title"
    @button = "visits.new_button"
    @store = Store.find(params[:id])
    @dishes = @store.menu.get_dish_hash
    # if a session cart already existed for same store we keep it otherwise put in new one
    if !(session[:store_id] and session[:store_id] == Hid.enc(@store.id) and session[:cart])
      session[:store_id] = params[:id]
      session[:cart] = Cart.new
    end
  end
  
  def create
    store = Store.find(session[:store_id])
    @visit.user_id = current_user.id
    @visit.store_id = store.id
    @visit.city_id = store.city_id
    #2do: not sure storing city_id in both visit and store is optimal...
    @visit.visit_date = params[:visit][:visit_date]
    #2do: need to check again that date not in future or too far past (do it in model.rb)

    @need_confirmation_list = Array.new
    
    update_dish_reviews_from_cart
    
    if @need_confirmation_list.size > 0
      @title = "visits.confirm_title"
      @button = "confirm_button"
      @button2 = "cancel_button"
      render 'visits/confirm_visit'
    else  
      if @visit.save
        session[:cart] = nil
        redirect_to edit_parameters_visit_path(@visit), :flash => { :success => "Visit created!" }
      else
        #2do: error messages
      end
    end
  end

  def edit
    @title = "visits.edit_title"
    @button = "update_button"
    @store = @visit.store
    @dishes = @store.menu.get_dish_hash
    # if a session cart already existed for same store we keep it otherwise put in new one
    if !(session[:store_id] and session[:store_id] == Hid.enc(@store.id) and session[:cart])
      session[:store_id] = params[:id]
      session[:cart] = Cart.new
      #load existing items
      for dr in @visit.dish_reviews
        session[:cart].add_dish(dr.dish.name, dr.dish.price, Hid.enc(dr.dish.id))
      end
    end
  end

  def update
    @need_confirmation_list = Array.new
	  
    update_dish_reviews_from_cart
    
    if @need_confirmation_list.size > 0
      @title = "visits.confirm_title"
      @button = "confirm_button"
      @button2 = "cancel_button"
      render 'visits/confirm_visit'
    else  
      if @visit.save
        session[:cart] = nil
        redirect_to edit_parameters_visit_path(@visit), :flash => { :success => "Visit updated!" }
      else
        #2do:
      end    
    end
  end
  
  def change_cart
    #this action does not run through authorization but that's ok as can only effect the session cart
    if params[:delall]
      session[:cart] = Cart.new
    elsif params[:del]
      session[:cart].remove_dish(params[:dish_name])
    else
      if !dish = Dish.find(Hid.dec(params[:dish_id])) and params[:dish_name] and params[:dish_name].size > 0 
        #new dish, to be added to DB
        session[:cart].add_dish(params[:dish_name], 0, -1)
      else
        session[:cart].add_dish(dish.name, dish.price, Hid.enc(dish.id))
      end
    end
    respond_to do |format|
      format.html { render :partial => "cart", :object => session[:cart] }
      format.js 
    end
    # 2do: use number_to_currency(cart_item.price) in views
  end
  
  def edit_parameters
    @title = "visits.edit_title"
    @button = "update_button"
    @button2 = "visits.edit_dishes_button"
    @button3 = "visits.delete_button"
    @store = @visit.store
    @rating_options = [[0,0],[1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7],[8,8],[9,9],[10,10]]
  end  
  
  def update_parameters
    @visit.user_id = current_user.id
    @visit.overall_rating = params[:visit][:overall_rating]
    @visit.service_rating = params[:visit][:service_rating]
    @visit.speed_rating = params[:visit][:speed_rating]
    @visit.mood_rating = params[:visit][:mood_rating]
    @visit.value_rating = params[:visit][:value_rating]
    @visit.tagline = params[:visit][:tagline]
    @visit.review = simple_format(params[:visit][:review])
    @visit.guest_number = params[:visit][:guest_number]
    #2do: need to check again that date not in future or too far past (do it in model.rb)
    @visit.visit_date = params[:visit][:visit_date]

    @visit.dish_reviews.each_with_index do | dr, i |
      if params['dr'+i.to_s]
        params['dr'+i.to_s].each_with_index do | pic, j |
          tmppic = Picture.new
          # hackish way of setting the filename to a new random string - note it can't be done in image_uploader as the random routine gets called for each version of picture which breaks things
          zid = Hid.enc(dr.id * 10000 + j)
          pic.original_filename = "#{zid}#{File.extname(pic.original_filename)}" 
          tmppic.image = pic
          tmppic.genre = ""
          tmppic.user_id = current_user.id
          tmppic.vote_count = 0
          tmppic.rank = 0
          dr.pictures << tmppic    
        end
      end
    end
    
    if @visit.save
      # we also call this method with an alternative submit that requests (after the changes are saved) to redirect to the change dishes page
      # this is done so we don't lose any changes the user may have already made to the page
      if params[:change_dish]
        redirect_to edit_visit_path(@visit), :flash => { :success => "Visit updated!" }
      else      
        redirect_to visit_path(@visit), :flash => { :success => "Visit updated!" }
      end  
    else
      #2do:
    end    
  end
  
  def destroy
    @visit.destroy
    redirect_to root_path, :flash => { :success => "Visit deleted!" }
  end
  
  private
    def update_dish_reviews_from_cart
      for ci in session[:cart].cart_items
        if ci.dish_id == -1
          if params[:confirmed]
            # dish not already in DB 2do: create new dish, then dishreview, then add to visit
            # also need to check at some point the dish with that name doesn't already exist
          else
            @need_confirmation_list << { :type => :new, :name => ci.name }
          end
        else      
          # this method also called when user is updating their dish selection hence the possibility that the dish_reviews already exist
          if dreview = @visit.dish_reviews.find_by_dish_id(Dish.find(Hid.dec(ci.dish_id)).id)
            if ci.quantity == 0
              if params[:confirmed]
                dreview.destroy
              else
                @need_confirmation_list << { :type => :del, :name => ci.name }
              end
            else
              dreview.quantity = ci.quantity
              @visit.dish_reviews << dreview
            end
          elsif ci.quantity > 0  
            dreview = DishReview.new
            dreview.user_id = current_user.id
            dreview.dish_id = Dish.find(Hid.dec(ci.dish_id)).id
            dreview.quantity = ci.quantity
            @visit.dish_reviews << dreview
          end
        end  
      end
    end
    
    def sort_column
      Visit.column_names.include?(params[:sort]) ? params[:sort] : "visit_date"
    end
    
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end