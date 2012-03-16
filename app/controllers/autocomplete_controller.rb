class AutocompleteController < ApplicationController
  def cities
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      cities = City.where("name ILIKE ?", like)
    else
      #cities = City.all
    end
    list = cities.map {|c| Hash[ id: c.id, label: c.name, name: c.name]}
    render json: list
  end

  def stores
    #p params.to_s
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      stores = Store.where("name ILIKE ? and city_id = ?", like, params[:city_id])
    else
      #stores = Store.all
    end
    list = stores.map {|s| Hash[ id: s.id, label: s.name, name: s.name]}
    render json: list
  end

  def dishes
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      dishes = Dish.where("name ILIKE ? and store_id = ?", like, params[:store_id])
    else
      #stores = Store.all
    end
    list = dishes.map {|d| Hash[ id: d.id, label: d.name, name: d.name]}
    render json: list
  end
end
