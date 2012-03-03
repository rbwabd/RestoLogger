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
end

