# == Schema Information
#
# Table name: stores
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  shortname  :string(255)
#  email      :string(255)
#  phone      :string(255)
#  phone2     :string(255)
#  address    :string(255)
#  postcode   :string(255)
#  city_id    :integer
#  chain_id   :integer
#  keyword    :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  fxcode     :string(255)
#  user_id    :integer
#

class Store < ActiveRecord::Base
  belongs_to :city
  attr_accessible :name, :address
  
  has_one :menu, :dependent => :destroy
  has_many :store_type_relationships, :dependent => :destroy
  has_many :dishes, :through => :menu
  
  def self.create_store(params)
    #puts params[:city]
    city = City.find_city(params[:city], params[:state], params[:country])
    if !city.empty?
      Store.create(:name => params[:name], :address => params[:address], :postcode => params[:postcode], :phone => params[:phone], :city => params[:city], :city_id => city.first.id);
    else
      Store.create(:name => params[:name], :address => params[:address], :postcode => params[:postcode], :phone => params[:phone], :city => params[:city]);
    end
  end
  
  def self.store_search(name, city, state, country)    
    #http://code.google.com/apis/ajax/playground/#center_localsearch
    result_hash = nil
    store_id = nil
    search_url = nil
    results = Array.new
    
    google_url = 'https://www.google.com/search?as_q='+city+'+'+name
    #file for debugging purposes
    #File.open("tmpzfile.txt",'w') do |filea|
      open("#{google_url}") do |f|
        #raise 'web service error' if (f.status.first != '200')
        f.each_line do |line|
          #filea.puts line
          if result_hash = Store.find_str(line, 0, ';cid=', '"') and result_hash[:result_string].size <= 20 then
            store_id = result_hash[:result_string]
            search_url = 'http://maps.google.com/maps/place?cid='+store_id

            found = Hash.new
            found[:store_id] = store_id
            #File.open("tmpzfile.txt",'w') do |filea|
              open("#{search_url}") do |f2|
                #raise 'web service error' if (f.status.first != '200')
                f2.each_line do |line|
                  #filea.puts line
                  if result_hash = Store.find_str(line, 0, 'gw:businessname="', '"') then
                    found[:name] = result_hash[:result_string]
                  end  
                  if result_hash = Store.find_str(line, 0, 'gw:address="', '"') then
                    found[:address] = result_hash[:result_string]
                  end  
                  if result_hash = Store.find_str(line, 0, 'gw:country="', '"') then
                    found[:country] = result_hash[:result_string]
                  end  
                  if result_hash = Store.find_str(line, 0, 'gw:phone="', '"') then
                    found[:phone] = result_hash[:result_string]
                  end  
                end
              end
            #end
            results << found
          end  
        end
      end
    #end
   
    return results
  end
    
  def id_encoded
    Hid.enc( self.id )
  end
  def to_param
    Hid.enc( self.id )
  end

  private
    def self.find_str(line, offset, sstr1, sstr2)
      idx1=line.index(sstr1, offset)
      if idx1
        idx1 += sstr1.size
        idx2 = line.index(sstr2, idx1)
        return {:offset => idx2, :result_string => CGI::unescapeHTML(line.slice(idx1, idx2-idx1))}
      end
      return nil
    end  
end
