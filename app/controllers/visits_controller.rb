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
    session[:store_id] = params[:id]
    cart = Cart.new
    cart.add_dish("Straw Mushroom Chicken Soup", 3, 342)
    cart.add_dish("Squid with soy sauce", 4, 341)
    cart.add_dish("Thinly sliced cucumber mixed with sesame seed, garlic, spring onion, vinegar-appetizing side", 5.8, 344)
    cart.add_dish("Thinly sliced cucumber mixed with sesame seed, garlic, spring onion, vinegar-appetizing side", 4.7, 344)
    session[:cart] = cart
  end
  
  def create
    @visit=Visit.new
    @visit.user_id=current_user.id
    #@visit.overall_rating=
    #@visit.service_rating=
    #@visit.speed_rating=
    #@visit.mood_rating=
    @visit.tagline=params[:visit][:tagline]
    @visit.review=params[:visit][:review]
    #@visit.guest_number=
    @visit.city_id=params[:store][:city_id]
    @visit.store_id=params[:store][:id]
    @visit.visit_date=params[:visit][:visit_date]
    
    if !params[:visit][:dish_reviews_attributes].nil?
      for dr in params[:visit][:dish_reviews_attributes].values
        @dreview=DishReview.new
        @dreview.rating=dr[:rating]
        @dreview.tagline=dr[:tagline]
        @dreview.review=dr[:review]
        @dreview.dish_id=dr[:dish_id]
        @dreview.user_id=current_user.id
        if !dr[:pictures_attributes].nil?
          for tmppic in dr[:pictures_attributes].values
            @pic=Picture.new
            @pic.genre=tmppic[:genre]
            @pic.image=tmppic[:image]
            @dreview.pictures << @pic
          end
        end
        @visit.dish_reviews << @dreview      
      end
    end
    if @visit.save
      redirect_to root_path, :flash => { :success => "Visit created!" }
    else
      @feed_items = []
      render 'pages/home'
    end
  end
  
  def add_to_cart
    @visit  = Visit.new
    @store = Store.find(session[:store_id])
    if !dish=Dish.find(params[:dish_id]) and params[:dish_name] and params[:dish_name].size > 0 
      dish=Dish.new({ :name => params[:dish_name], :price => 3.4 })
    end
    session[:cart].add_dish(dish.name, dish.price, dish.id)
    render "visits/new"
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