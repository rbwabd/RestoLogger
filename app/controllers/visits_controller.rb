class VisitsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user, :only => :destroy

  def index
    @title = "index_title"
    @visits = @current_user.visits.paginate(:page => params[:page])
  end
  
  def show
    @visit = Visit.new
  end

  def new
    @visit  = Visit.new
    @title = "new_title"
    @button = "new_button"
    @city = City.find_city("London", "London", "United Kingdom")
    @country = Country.find_by_name("United Kingdom")
    @state = State.find_by_name("London")
    #@dish1 = DishReview.new(:dish_id => 3)
    #@dish2 = DishReview.new(:dish_id => 4)
    #@visit.dish_reviews << @dish1
    #@visit.dish_reviews << @dish2
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
    @visit.city_id=params[:visit][:city_id]
    @visit.store_id=params[:visit][:store_id]
    @visit.visit_date=params[:visit][:visit_date]
    
    if !params[:visit][:dish_reviews_attributes].nil?
      for dr in params[:visit][:dish_reviews_attributes].values
        @dreview=DishReview.new
        @dreview.rating=dr[:rating]
        @dreview.tagline=dr[:tagline]
        @dreview.review=dr[:review]
        @dreview.dish_id=dr[:dish_id]
        @dreview.user_id=current_user.id
        @visit.dish_reviews << @dreview      
      end
    end
    if !params[:visit][:pictures_attributes].nil?
      for tmppic in params[:visit][:pictures_attributes].values
        @pic=Picture.new
        @pic.url=tmppic[:image]
        @pic.image=tmppic[:image]
        @visit.pictures << @pic
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