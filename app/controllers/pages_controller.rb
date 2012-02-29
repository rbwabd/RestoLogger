class PagesController < ApplicationController
  def home
    @title = "Home"
    if user_signed_in?
      @visit = Visit.new
      @feed_items = current_user.feed.paginate(:page => params[:page])
    end
  end

  def contact
    @title = "Contact"
  end
  
  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
    @picture = Picture.new()
    @picture.remote_image_url=current_user.facebook.picture
    @picture.genre="ProfilePic"
    if @picture.save
      flash.now[:notice] = "Successfully created picture."
    else 
      flash[:notice] = "failed creating picture."
      redirect_to root_path
    end  
  end
end
