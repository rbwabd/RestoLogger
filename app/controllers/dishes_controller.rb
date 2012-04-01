class DishesController < ApplicationController
  #before_filter :authenticate_user!
  #before_filter :authorized_user, :only => :destroy
  before_filter :decode_id
  
  def index
    @title = "dishes.index_title"
    #@dishes = Dish.all.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    @title = "dishes.show_title"
    @button = "dishes.new_visit_button"
    @dish = Dish.find(params[:id])
  end
  
  def destroy
    @dish.destroy
    redirect_to root_path, :flash => { :success => "Dish deleted!" }
  end
end