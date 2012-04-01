RestoLogger::Application.routes.draw do
  
  get "autocomplete/cities"
  get "autocomplete/stores"
  get "autocomplete/dishes"
  
  get "states/create"
  get "states/destroy"
  get "countries/create"
  get "countries/destroy"
  
  match '/add_menu',                :to => 'stores#add_menu'
  match '/submit_menu',             :to => 'stores#submit_menu'
  match '/confirm_menu',            :to => 'stores#confirm_menu'
  match '/save_menu',               :to => 'stores#save_menu'
  match '/edit_menu_order',         :to => 'stores#edit_menu_order'
  match '/update_menu_order',       :to => 'stores#update_menu_order'
  match '/show_menu',               :to => 'stores#show_menu'
  match '/search_store',            :to => 'stores#search'
  match '/search_store_results',    :to => 'stores#search_results'
  match '/change_cart',             :to => 'visits#change_cart'
  match '/edit_visit_parameters',   :to => 'visits#edit_parameters'
  match '/update_visit_parameters', :to => 'visits#update_parameters'
  
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

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :sessions,        :only => [:new, :create, :destroy]
  resources :visits
  #resources :dish_reviews,    :only => [:destroy]
  resources :relationships,   :only => [:create, :destroy]
	resources :authentications
  resources :stores
  resources :dishes
  
	root :to => "authentications#index"
	#root :to => "pages#home"

  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'
end
