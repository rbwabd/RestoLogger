class DishReviewsController < ApplicationController
  before_filter :decode_id
  before_filter :authenticate_user!
  load_and_authorize_resource 

  def delete_picture
    pic = @dish_review.pictures.find(Hid.dec(params[:pic_id]))
    if pic
      pic.destroy
    end
    respond_to do |format|
      format.html {}
      format.js
    end    
  end
  
  def destroy
    @dish_review.destroy
  end

end