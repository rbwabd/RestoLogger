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
        offset=0
        if !@store_url then 
          if results=find_str(line, offset, 'meta property="og:url" content="', '">') then
            @store_url=results[:result_string]
            offset=results[:offset]
          end  
        end
        if !@store_name then 
          if results=find_str(line, offset, '<meta property="og:title" content="', '">') then
            @store_name=results[:result_string]
            offset=results[:offset]
          end  
        end
        if !@store_address then 
          if results=find_str(line, offset, '<span class="street-address">', '</span>') then
            store_street=results[:result_string]
            offset=results[:offset]
            results=find_str(line, offset, '<span class="locality">', '</span> <span class="postal-code">')
            store_locality=results[:result_string]
            offset=results[:offset]
            results=find_str(line, offset, '</span> <span class="postal-code">', '</span><br>')
            store_zipcode=results[:result_string]
            @store_address=store_street+", "+store_locality+" "+store_zipcode
          end
        end
      }  
    }
  end
  
  private
    def find_str(line, offset, sstr1, sstr2)
      idx1=line.index(sstr1, offset)
      if idx1
        idx2=line.index(sstr2, offset)
        idx1+=sstr1.size
        return {:offset => idx2, :result_string => line.slice(idx1, idx2-idx1)}
      end
      return nil
    end
end
