RestoLogger::Application.routes.draw do
  
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "authentications#index"
  
  # Resource routing: covers index, show, new, edit, create, update and destroy actions
    resources :users do
      collection do
        get 'show_my_following'
        get 'update_friend_list'
      end
    end  
    resources :stores do 
      collection do
        get 'search'
        post 'search_results'
      end
      member do
        get 'show_search_result'
      end
    end
    resources :dish_reviews,    :only => [:destroy] do
      member do
        get 'delete_picture'
      end
    end
    resources :menus,           :only => [:show, :edit, :update] do
      member do
        get 'add'
        post 'confirm'
        post 'save'
        get 'edit_order'
        put 'update_order'      
      end
    end
    resources :dishes,          :only => [:show, :destroy]
    resources :visits,          :except => :index do
      member do
        get 'edit_parameters'
        put 'update_parameters'
      end
      collection do 
        get 'show_friend'
      end
    end  
    resources :visit_reports, :only => :index
    resources :store_lists do
      member do
        get 'add_item'
      end
    end
    resources :store_list_entries, :only => :destroy
    resources :visited_store_list_reports, :only => :index
    
    resources :sessions,        :only => [:create, :destroy]
    resources :authentications, :only => [:index, :destroy]
    #resources :countries,       :only => [:create, :destroy]
    #resources :states,          :only => [:create, :destroy]
    #resources :relationships,   :only => [:create, :destroy]
    
  # Specific Routes
    match '/change_cart',             :to => 'visits#change_cart'
    match '/contact',                 :to => 'pages#contact'
    match '/about',                   :to => 'pages#about'
    match '/help',                    :to => 'pages#help'   
    
  # JQuery-UI autocomplete 
    get "autocomplete/cities"
    get "autocomplete/stores"
    get "autocomplete/dishes"

  # devise
    devise_for :users  #, :skip => [:sessions]
    devise_scope :user do
      get 'signin' => 'authentications#index',    :as => :new_user_session    #redirected to after new user signs in
      #this is a dummy - we have no signin page at the moment so no create page
      #post 'signin' => 'sessions#create', :as => :user_session
      #post 'signin' => 'users#show',              :as => :user_session
      delete 'signout' => 'sessions#destroy',     :as => :destroy_user_session
      match '/auth/:provider/callback' => 'sessions#create' 
    end
end
