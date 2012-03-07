class City < ActiveRecord::Base
  attr_accessible :name, :country_id, :state_id
  belongs_to :Country
  belongs_to :State

  def self.create_city(city_name, state_name, country_name)
    #city=select("city.id").joins(:state).order("countpages.counts desc").limit(5)
    #find_by_sql("select posts.id,posts.title from posts inner join countpages on countpages.post_id = posts.id order by countpages.counts desc limit 5")
    
    country=Country.find_by_name(country_name)
    if !country then
     country=Country.create(:name => country_name)
     state=State.create(:name => state_name, :country_id => country.id)
     city=City.create(:name => city_name, :country_id => country.id, :state_id => state.id);
    else
      state=State.find_by_name_and_country_id(state_name, country.id)
      if !state then
        state=State.create(:name => state_name, :country_id => country.id)
        city=City.create(:name => city_name, :country_id => country.id, :state_id => state.id);
      else
        city=City.find_by_name_and_country_id_and_state_id(city_name, country.id, state.id)
        if (!city) then
          city=City.create(:name => city_name, :country_id => country.id, :state_id => state.id);
        else
          #puts "City already in DB!"
        end
      end
    end
  end
  
  def self.find_city(city_name, state_name, country_name)
    #the below also works although a bit dirty as returns just object with the id rather than full object
    #city=Country.select("cities.id").joins(:states => :cities).where('cities.name' => city_name, 'states.name' => state_name, 'countries.name' => country_name)
    City.find(:all, :joins => "INNER JOIN states ON (states.id = cities.state_id) INNER JOIN countries on (countries.id=cities.country_id)", :conditions => [ "cities.name = ? and states.name = ? and countries.name = ?", city_name, state_name, country_name]) 
  end
end

