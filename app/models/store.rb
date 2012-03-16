class Store < ActiveRecord::Base
  belongs_to :city
  
  def self.create_store(params)
    #puts params[:city]
    city=City.find_city(params[:city], params[:state], params[:country])
    if !city.empty?
      Store.create(:name => params[:name], :address => params[:address], :postcode => params[:postcode], :phone => params[:phone], :city => params[:city], :city_id => city.first.id);
    else
      Store.create(:name => params[:name], :address => params[:address], :postcode => params[:postcode], :phone => params[:phone], :city => params[:city]);
    end
  end
end
