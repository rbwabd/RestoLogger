RestoLogger::Application.routes.draw do
  
  root :to => "authentications#index"
  
  # Resource routing: covers index, show, new, edit, create, update and destroy actions
    resources :users
    resources :stores do 
      collection do
        get 'search'
        post 'search_results'
      end
    end
    resources :dish_reviews,    :only => [:destroy]
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
    resources :visits do
      member do
        get 'edit_parameters'
        put 'update_parameters'
      end
    end  
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
      #get 'signin' => 'authentications#index',    :as => :new_user_session
      #this is a dummy - we have no signin page at the moment so no create page
      #post 'signin' => 'sessions#create', :as => :user_session
      #post 'signin' => 'users#show',              :as => :user_session
      delete 'signout' => 'sessions#destroy',     :as => :destroy_user_session
      match '/auth/:provider/callback' => 'sessions#create' 
    end
end
