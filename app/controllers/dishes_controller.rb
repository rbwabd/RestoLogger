class DishesController < ApplicationController
  before_filter :decode_id
  before_filter :authenticate_user!
  load_and_authorize_resource

  def show
    @title = "dishes.show_title"
    @button = "dishes.new_visit_button"
  end
  
  def destroy
    @dish.destroy
    redirect_to root_path, :flash => { :success => "Dish deleted!" }
  end
end