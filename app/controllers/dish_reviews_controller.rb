class DishReviewsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorized_user, :only => :destroy

  def destroy
    @dr.destroy
  end
  
  private
    def authorized_user
      @dr = current_user.dish_reviews.find_by_zid(params[:id])
      redirect_to root_path if @dr.nil?
    end
end