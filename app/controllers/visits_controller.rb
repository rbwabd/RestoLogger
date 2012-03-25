class VisitsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user, :only => :destroy

  def index
    @title = "visits.index_title"
    @visits = @current_user.visits.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @title = "visits.show_title"
    @visit = Visit.find(params[:id])
    @store = Store.find(@visit.store_id)
    @city = City.find(@visit.city_id)
  end

  def new
    @title = "visits.new_title"
    @button = "visits.new_button"
    @visit  = Visit.new
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
    visit.visit_date = params[:visit][:visit_date]
    
    for ci in session[:cart].cart_items
      dreview = DishReview.new
      dreview.user_id = current_user.id
      dreview.dish_id = dr.dish_id

      visit.dish_reviews << dreview      
    end
    if visit.save
      session[:cart] = nil
      redirect_to root_path, :flash => { :success => "Visit created!" }
    else
      #2do: error messages
    end
  end
  
  def change_cart
    if params[:delall]
      session[:cart] = Cart.new
    elsif params[:del]
      session[:cart].remove_dish(params[:dish_name])
    else
      if !dish=Dish.find(params[:dish_id]) and params[:dish_name] and params[:dish_name].size > 0 
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
end