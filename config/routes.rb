RestoLogger::Application.routes.draw do
  
  root :to => "authentications#index"
  
  # Resource routing: covers index, show, new, edit, create, update and destroy actions
    resources :sessions,        :only => [:new, :create, :destroy]
    #resources :dish_reviews,    :only => [:destroy]
    resources :relationships,   :only => [:create, :destroy]
    resources :authentications
    resources :countries,       :only => [:create, :destroy]
    resources :states,          :only => [:create, :destroy]
    #resources :dishes
    resources :visits do
      member do
        get 'edit_parameters'
        put 'update_parameters'
      end
    end  
    resources :stores do 
      collection do
        get 'search'
        post 'search_results'
      end
      member do
        get 'add_menu'
        post 'submit_menu'
        post 'save_menu'
        get 'show_menu'
        get 'edit_menu_order'
        put 'update_menu_order'
      end
    end
    
  # Specific Routes
    match '/change_cart',             :to => 'visits#change_cart'
    match '/contact',                 :to => 'pages#contact'
    match '/about',                   :to => 'pages#about'
    match '/help',                    :to => 'pages#help'   
    
  #JQuery-UI autocomplete stuff  
    get "autocomplete/cities"
    get "autocomplete/stores"
    get "autocomplete/dishes"

  #devise stuff  
  devise_for :users  #, :skip => [:sessions]
  #as :user do is the same as devise_scope :user do
	as :user do
		get 'signin' => 'authentications#index',    :as => :new_user_session
		#this is a dummy - we have no signin page at the moment so no create page
		#post 'signin' => 'sessions#create', :as => :user_session
		post 'signin' => 'users#show',              :as => :user_session
		delete 'signout' => 'sessions#destroy',     :as => :destroy_user_session
		match '/auth/:provider/callback' => 'sessions#create' 
	end
end
