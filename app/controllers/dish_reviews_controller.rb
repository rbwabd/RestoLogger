class DishReviewsController < ApplicationController
  before_filter :decode_id
  before_filter :authenticate_user!
  load_and_authorize_resource 

  def destroy
    @dish_review.destroy
  end

end