SampleApp::Application.routes.draw do
  
	devise_for :users#, :skip => [:sessions]
	#as :user do is the same as devise_scope :user do
	as :user do
		get 'signin' => 'authentications#index', :as => :new_user_session
		#this is a dummy - we have no signin page at the moment so no create page
		#post 'signin' => 'sessions#create', :as => :user_session
		post 'signin' => 'users#show', :as => :user_session
		delete 'signout' => 'sessions#destroy', :as => :destroy_user_session
		match '/auth/:provider/callback' => 'sessions#create' 
	end

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :sessions,      :only => [:new, :create, :destroy]
  resources :visits,    		:only => [:create, :destroy]
  resources :relationships, :only => [:create, :destroy]
	resources :authentications#, :only => [:destroy]
  
	root :to => "authentications#index"
	#root :to => "pages#home"

  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'
end
