class VisitsController < ApplicationController
  before_filter :decode_id
  before_filter :authenticate_user!
  load_and_authorize_resource :except => [:change_cart, :show_friend]
  
  def show
    @store = Store.find(@visit.store_id)
    @city = City.find(@visit.city_id)
  end

  def new
    @button = 'visits.new_button'
    @store = Store.find(params[:id])
    @dishes = @store.menu.get_dish_hash
    # if a session cart already existed for same store we keep it otherwise put in new one
    if !(session[:store_id] and session[:store_id].to_i == @store.id and session[:cart])
      session[:store_id] = params[:id]
      session[:cart] = Cart.new
    end
  end
  
  def create
    store = Store.find(session[:store_id])
    @visit.user_id = current_user.id
    @visit.store_id = store.id
    @visit.city_id = store.city_id
    #2do: not sure storing city_id in both visit and store is optimal...
    @visit.visit_date = params[:visit][:visit_date]
    #2do: need to check again that date not in future or too far past (do it in model.rb)

    @need_confirmation_list = Array.new
    
    update_dish_reviews_from_cart
    
    if @need_confirmation_list.size > 0
      render 'visits/confirm_visit'
    else  
      if @visit.save
        #update visit_store_list entry
        vsle = current_user.visited_store_list.visited_store_list_entries.find_by_store_id(store.id)
        if vsle
          vsle.visit_cnt += 1
          vsle.last_visit_date = @visit.visit_date
        else
          vsle = VisitedStoreListEntry.new( :visited_store_list_id => current_user.visited_store_list.id,
                                            :store_id => store.id, 
                                            :visit_cnt => 1, 
                                            :last_visit_date => @visit.visit_date )
        end
        vsle.save
        session[:cart] = nil
        redirect_to edit_parameters_visit_path(@visit), :flash => { :success => "Visit created!" }
      else
        #2do: error messages
      end
    end
  end

  def edit
    @button = "update_button"
    @store = @visit.store
    @dishes = @store.menu.get_dish_hash
    # if a session cart already existed for same store we keep it otherwise put in new one
    if !(session[:store_id] and session[:store_id] == Hid.enc(@store.id) and session[:cart])
      session[:store_id] = params[:id]
      session[:cart] = Cart.new
      #load existing items
      for dr in @visit.dish_reviews
        session[:cart].add_dish(dr.dish.name, dr.dish.price, Hid.enc(dr.dish.id))
      end
    end
  end

  def update
    @need_confirmation_list = Array.new
	  
    update_dish_reviews_from_cart
    
    if @need_confirmation_list.size > 0
      render 'visits/confirm_visit'
    else  
      if @visit.save
        session[:cart] = nil
        redirect_to edit_parameters_visit_path(@visit), :flash => { :success => "Visit updated!" }
      else
        #2do:
      end    
    end
  end
  
  def change_cart
    #this action does not run through authorization but that's ok as can only effect the session cart
    if params[:delall]
      session[:cart] = Cart.new
    elsif params[:del]
      session[:cart].remove_dish(params[:dish_search_name])
    else
      if !dish = Dish.find(Hid.dec(params[:dish_id])) and params[:dish_search_name] and params[:dish_name].size > 0 
        #new dish, to be added to DB
        session[:cart].add_dish(params[:dish_search_name], 0, -1)
      else
        session[:cart].add_dish(dish.name, dish.price, Hid.enc(dish.id))
      end
    end

    respond_to do |format|
      format.html { render :partial => "cart", :object => session[:cart] }
      format.js 
    end
    # 2do: use number_to_currency(cart_item.price) in views
  end
  
  def edit_parameters
    @store = @visit.store
    @rating_options = [[0,0],[1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7],[8,8],[9,9],[10,10]]
  end  
  
  def update_parameters
    @visit.user_id = current_user.id
    #2do: need to check again that date not in future or too far past (do it in model.rb)
    @visit.visibility_mask = params[:visit][:visibility_mask]
    @visit.visit_date = params[:visit][:visit_date]
    @visit.guest_number = params[:visit][:guest_number]
    @visit.spend = params[:visit][:spend]
    @visit.overall_rating = params[:visit][:overall_rating]
    @visit.service_rating = params[:visit][:service_rating]
    @visit.speed_rating = params[:visit][:speed_rating]
    @visit.mood_rating = params[:visit][:mood_rating]
    @visit.value_rating = params[:visit][:value_rating]
    @visit.tagline = params[:visit][:tagline]
    @visit.review = params[:visit][:review]
    @visit.private_comment = params[:visit][:private_comment]

    @visit.dish_reviews.each do |dr|
      tag = 'dish_review_' + Hid.enc(dr.id)
      dr.rating = params[tag][:rating]
      dr.tagline = params[tag][:tagline]
      j = dr.pictures.size
      if img = params[tag][:image]
        img.each_with_index do | pic, i |
          tmppic = Picture.new
          # hackish way of setting the filename to a string based on dish_review id and a counter. Maybe there is a way of setting this in the pic uploader instead.
          # 2do: a bug is that if user deletes a pic and add another one, filename will be same and old pic may have stayed in cache
          # only way to avoid that while guaranteeing no collision is to add a field in dish_review counting all pic uploads incl deletes... not very efficient...
          pic.original_filename = "#{Hid.enc(dr.id * 10000 + i + j)}#{File.extname(pic.original_filename)}" 
          tmppic.image = pic
          tmppic.user_id = current_user.id
          tmppic.vote_count = 0
          tmppic.rank = 0
          dr.pictures << tmppic    
        end
      end
    end
    
    if @visit.save
      # we also call this method with an alternative submit that requests (after the changes are saved) to redirect to the change dishes page
      # this is done so we don't lose any changes the user may have already made to the page
      if params[:change_dish]
        redirect_to edit_visit_path(@visit), :flash => { :success => "Visit updated!" }
      else      
        redirect_to visit_path(@visit), :flash => { :success => "Visit updated!" }
      end  
    else
      #2do:
    end    
  end
  
  def destroy
    @visit.destroy
    redirect_to root_path, :flash => { :success => "Visit deleted!" }
  end
  
  def show_friend
    authorize! :show_friend, Visit
    @visits = Store.joins(:visits => { :user => :reverse_relationships }).where("relationships.follower_id = ? and relationships.followed_id = visits.user_id", current_user.id).select("stores.id, stores.name, count(DISTINCT visits.user_id) as user_cnt").group("stores.id")
    
    
=begin
    @visit_hash = Hash.new
    
    for v in visits
      store_id = v.store.id
      if !@visit_hash[store_id]  
        @visit_hash[store_id] = Hash.new 
        #@visit_hash[store_id][:id] = v.store.id
        @visit_hash[store_id][:name] = v.store.name
        @visit_hash[store_id][:category] = v.store.store_types.collect{|st| st.name}.join(", ")
        @visit_hash[store_id][:users] = Hash.new
      end
      if @visit_hash[store_id][:users][v.user_id]
        @visit_hash[store_id][:users][v.user_id][:cnt] += 1
        if @visit_hash[store_id][:users][v.user_id][:last] < v.visit_date
          @visit_hash[store_id][:users][v.user_id][:last] = v.visit_date
        end
      else
        @visit_hash[store_id][:users][v.user_id] = Hash.new
        #@visit_hash[store_id][:users][v.user_id][:id] = v.user_id
        @visit_hash[store_id][:users][v.user_id][:name] = v.user.name
        @visit_hash[store_id][:users][v.user_id][:cnt] = 1
        @visit_hash[store_id][:users][v.user_id][:last] = v.visit_date
      end
    end
=end
  end
  
  private
    def update_dish_reviews_from_cart
      for ci in session[:cart].cart_items
        if ci.dish_id == -1
          if params[:confirmed]
            # dish not already in DB 2do: create new dish, then dishreview, then add to visit
            # also need to check at some point the dish with that name doesn't already exist
          else
            @need_confirmation_list << { :type => :new, :name => ci.name }
          end
        else      
          # this method also called when user is updating their dish selection hence the possibility that the dish_reviews already exist
          if dreview = @visit.dish_reviews.find_by_dish_id(Dish.find(Hid.dec(ci.dish_id)).id)
            if ci.quantity == 0
              if params[:confirmed]
                dreview.destroy
              else
                @need_confirmation_list << { :type => :del, :name => ci.name }
              end
            else
              dreview.quantity = ci.quantity
              @visit.dish_reviews << dreview
            end
          elsif ci.quantity > 0  
            dreview = DishReview.new
            dreview.user_id = current_user.id
            dreview.dish_id = Dish.find(Hid.dec(ci.dish_id)).id
            dreview.quantity = ci.quantity
            @visit.dish_reviews << dreview
          end
        end  
      end
    end
end