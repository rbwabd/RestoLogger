SampleApp::Application.routes.draw do
  
	devise_for :users, :controllers => {:registrations => 'registrations'}

#	devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
#		get 'sign_in', :to => 'users/sessions#new', :as => :new_user_session
#		get 'sign_out', :to => 'users/sessions#destroy', :as => :destroy_user_session
#	end
	
	#omniauth stuff
	#match '/auth/:provider/callback' => 'authentications#create'
	devise_scope :user do
		#get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
		match '/auth/:provider/callback' => 'sessions#create' 
	end

  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :sessions,      :only => [:new, :create, :destroy]
  resources :microposts,    :only => [:create, :destroy]
  resources :relationships, :only => [:create, :destroy]
  
	
  root :to => "pages#home"

  match '/contact', :to => 'pages#contact'
  match '/about',   :to => 'pages#about'
  match '/help',    :to => 'pages#help'
  match '/signup',  :to => 'users#new'
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
end
