class AutocompleteController < ApplicationController
  def cities
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      #2do: ILIKE is slower than LIKE, so convert using a _lower_ index fieled
      #CREATE INDEX id_lower_content ON mytable(lower(column_name))
      cities = City.where("name ILIKE ?", like)
    else
      # 2do: cities = City.all
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
      # 2do: stores = Store.all
    end
    list = stores.map {|s| Hash[ id: s.zid, label: s.name, name: s.name]}
    render json: list
  end

  def dishes
    if params[:term]
      like= "%".concat(params[:term].concat("%"))
      dishes = Dish.where("name ILIKE ? and store_id = ?", like, session[:store_id])
    else
      # 2do: stores = Store.all
    end
    list = dishes.map {|d| Hash[ id: d.zid, label: d.name, name: d.name]}
    render json: list
  end
end
