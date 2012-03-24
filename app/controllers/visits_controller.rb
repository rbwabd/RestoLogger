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
    @cart_items = Array.new
    @cart_items << CartItem.new({ :name => "test1", :price => "3", :count => "1", :dish_id => "342" })
    @cart_items << CartItem.new({ :name => "test2", :price => "5.6", :count => "1", :dish_id => "341" })
    @cart_items << CartItem.new({ :name => "test3", :price => "4", :count => "1", :dish_id => "344" })
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