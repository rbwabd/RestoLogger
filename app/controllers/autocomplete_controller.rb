class AutocompleteController < ApplicationController
  def cities
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      cities = City.where("name like ?", like)
    else
      #cities = City.all
    end
    list = cities.map {|c| Hash[ id: c.id, label: c.name, name: c.name]}
    render json: list
  end

  def stores
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      stores = Store.where("name like ?", like)
    else
      #stores = Store.all
    end
    list = stores.map {|s| Hash[ id: s.id, label: s.name, name: s.name]}
    render json: list
  end
end
