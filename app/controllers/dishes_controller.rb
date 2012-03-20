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

  def new
    @title = "dishes.new_title"
    @button = "dishes.new_button"
    @dish  = Dish.new( {:name => params[:name], :address => params[:address]})
  end

  def create
    @dish = Dish.new
    @dish.city_id=params[:city][:id]

    if @dish.save
      redirect_to @dish, :flash => { :success => "New Dish Saved" }
    else
      @title = "dishes.new_title"
      @button = "dishes.new_button"
      @dish  = Dish.new( {:name => params[:dish][:name], :address => params[:dish][:address]})
      render 'new'
    end
  end
  
  def destroy
    @dish.destroy
    redirect_to root_path, :flash => { :success => "Dish deleted!" }
  end
end