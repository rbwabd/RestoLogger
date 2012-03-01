class City < ActiveRecord::Base

  def self.find_exact_city(cityname, statename, countryname)
    #city=select("city.id").joins(:state).order("countpages.counts desc").limit(5)
    find_by_sql("select posts.id,posts.title from posts inner join countpages on countpages.post_id = posts.id order by countpages.counts desc limit 5")
  end
end

