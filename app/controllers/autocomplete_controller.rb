class AutocompleteController < ApplicationController
  # This page includes autocomplete actions only and does not require authentication/authorization 

  def cities
    if params[:term]
      like = "%".concat(params[:term].concat("%"))
      #2do: ILIKE is slower than LIKE, so convert using a _lower_ index fieled
      #CREATE INDEX id_lower_content ON mytable(lower(column_name))
      cities = City.where("name ILIKE ?", like)
    else
      # 2do: cities = City.all
    end
    list = cities.map{|c| Hash[ id: c.id, label: c.name, name: c.name]}
    render json: list
  end

  def stores
    if params[:term]
      like = "%".concat(params[:term].concat("%"))
      stores = Store.where("name ILIKE ? and city_id = ?", like, params[:city_id])
    else
      # 2do: stores = Store.all
    end
    list = stores.map{|s| Hash[ id: Hid.enc(s.id), label: s.name, name: s.name]}
    render json: list
  end

  def dishes
    if params[:term]
      like = "%".concat(params[:term].concat("%"))
      store = Store.find(session[:store_id])
      dishes = Dish.includes(:menu).where("name ILIKE ? and menus.store_id = ?", like, store.id)
    else
      # 2do: stores = Store.all
    end
    list = dishes.map {|d| Hash[ id: Hid.enc(d.id), label: d.name, name: d.name]}
    render json: list
  end
end
