class PagesController < ApplicationController
  # This page should have static pages only and not require authentication/authorization 

  def home
    @title = "pages.home_title"
  end

  def contact
    @title = "pages.contact_title"
  end
  
  def about
    @title = "pages.about_title"
  end
  
  def help
    @title = "pages.help_title"
  end
end
