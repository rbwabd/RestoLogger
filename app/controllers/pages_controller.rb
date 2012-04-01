class PagesController < ApplicationController
  #require 'json'
  #require 'open-uri'

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
  end
end
