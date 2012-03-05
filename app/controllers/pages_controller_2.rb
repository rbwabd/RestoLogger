class PagesController < ApplicationController
require 'json'
require 'open-uri'

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
    @store_name = nil
    @store_address = nil
    @store_url = nil
        
    base_url = "http://www.yelp.co.uk/biz/the-ledbury-london"

    open("#{base_url}") {|f|
      #raise 'web service error' if (f.status.first != '200')
      f.each_line {|line|
        @tmpline=line
        if !@store_url then @store_url=find_str(@tmpline, 'meta property="og:url" content="', '">') end
        if !@store_name then @store_name=find_str(@tmpline, '<meta property="og:title" content="', '">') end
        if !@store_address then 
          store_street = find_str(@tmpline, '<span class="street-address">', '</span>')


          @store_address="   "
        #  if store_street
        #    store_locality =find_str(@tmpline, '<span class="locality">', '</span> <span class="postal-code">')
        #    store_zipcode =find_str(@tmpline, '</span> <span class="postal-code">', '</span><br>')
        #    @store_address=store_street+" "+store_locality+" "+store_zipcode
        #  end
        end
      }  
    }
  end
  
  private
    def find_str(linetmp, sstr1, sstr2)
      idx1=linetmp.index(sstr1)
      if idx1
        idx2=linetmp.index(sstr2)
        idx1+=sstr1.size
        @tmpline=linetmp.slice(idx1)
          p "hello"
          p "hello"
          p "hello"
          p "hello"
          p "hello"
          p @tmpline
          return linetmp.slice(idx1, idx2-idx1)
      end
      return nil
    end
end
