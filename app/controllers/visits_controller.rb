class VisitsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user, :only => :destroy
  
  def index
    @title = "index_title"
    @visits = @current_user.visits.paginate(:page => params[:page])
  end

  def new
    @visit  = Visit.new
    @title = "new_title"
    @button = "new_button"
    @city = City.new(:name => "London")
    @country = Country.find_by_name("United Kingdom")
    @state = State.find_by_name("London")
  end
  
  def create
    @visit = current_user.visits.build(params[:visit])
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