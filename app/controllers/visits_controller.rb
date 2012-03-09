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
    #@visit  = Visit.new(params[:visit])
    #@visit.user_id=current_user.id
    
    p params[:visit][:city_name]
    for dr in params[:visit][:dish_reviews_attributes].values
      p "rating "+dr[:rating]
      p "dish_id "+dr[:dish_id]
      p "dishname "+dr[:dish][:name]
    end
    
    #if @visit.save
      redirect_to root_path, :flash => { :success => "Visit created!" }
    #else
    #  @feed_items = []
    #  render 'pages/home'
    #end
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