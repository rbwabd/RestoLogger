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
    search_url = nil
    store_street = nil
    store_locality = nil
    store_zipcode = nil
    
    google_url= 'https://www.google.com/search?as_q=yelp+restaurant+boston+aujourd+hui'
    search = "london yelp restaurant red sun"

    #file for debugging purposes
    #File.open("tmpzfile.txt",'w') do |filea|
      open("#{google_url}") {|f|
        #raise 'web service error' if (f.status.first != '200')
        f.each_line {|line|
          #filea.puts line
          offset=0

          while offset != -1
            if !search_url && results=find_str(line, offset, '<h3 class="r"><a href="/url?q=', '"') then
              offset=results[:offset]
              tmp_url=CGI::unescape(results[:result_string])
              p tmp_url
              p "head"
              p "head"
              p "head"
              p "head"
              if tmp_url.index('yelp') then 
                idx1=tmp_url.index('&')
                search_url=tmp_url.slice(0,idx1)
                #@store_name=tmp_url.slice(0,idx1)
              end
            else
              # go to process next line
              offset = -1
            end  
          end
        }
      }
    #end

    open("#{search_url}") {|f|
      #raise 'web service error' if (f.status.first != '200')
      f.each_line {|line|
        offset=0
        if !@store_url && results=find_str(line, offset, 'meta property="og:url" content="', '">') then
          @store_url=results[:result_string]
          offset=results[:offset]
        end
        if !@store_name && results=find_str(line, offset, '<meta property="og:title" content="', '">') then
          @store_name=results[:result_string]
          offset=results[:offset]
        end
        if !store_street && results=find_str(line, offset, '<span class="street-address">', '</span>') then
          store_street=results[:result_string]
          if store_street.index("<br>") then
            store_street=store_street.split('<br>').join(', ')
          end
          offset=results[:offset]
        end 
        if !store_locality && results=find_str(line, offset, '<span class="locality">', '</span>') then
          store_locality=results[:result_string]
          offset=results[:offset]
        end
        if !store_zipcode && results=find_str(line, offset, '</span> <span class="postal-code">', '</span>') then
          store_zipcode=results[:result_string]
        end
      }  
      @store_address=store_street.to_s+", "+store_locality.to_s+" "+store_zipcode.to_s
    }   
  end
  
  private
    def find_str(line, offset, sstr1, sstr2)
      idx1=line.index(sstr1, offset)
      if idx1
        #puts "idx1o "+idx1.to_s
        #puts sstr1+" "+sstr2
        #puts line.slice(idx1, 60)
        idx1+=sstr1.size
        idx2=line.index(sstr2, idx1)
        #puts "idx1 "+idx1.to_s
        #puts "idx2 "+idx2.to_s
        return {:offset => idx2, :result_string => CGI::unescapeHTML(line.slice(idx1, idx2-idx1))}
      end
      return nil
    end
end
