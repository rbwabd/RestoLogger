class SessionsController < Devise::SessionsController

  def new
    @title = "Sign in"
  end
  
  def create
		omniauth = request.env["omniauth.auth"]

		#if right authentication found in DB, automatically refresh the token
		authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])#.tap do |a|
    #  a.update_attributes(:token => omniauth["credentials"]["token"]) if a
    #end
		if authentication && authentication.user.present?
			session[:user_id] = authentication.user.id 
			flash[:notice] = "Signed in successfully."
			#this is a devise method
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
			session[:user_id] = current_user.id 
			#not quite sure what this case protects against actually (user logged in but no auth in DB), maybe can delete this code later?
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth["credentials"]["token"])
			flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      user = User.new
			#the below also creates a new authentication object in DB
      user.apply_omniauth(omniauth)
      session[:user_id] = user.id 
			if user.save
        flash[:notice] = "Signed in new user successfully."
				sign_in_and_redirect(:user, user)
			else
        #session[:omniauth] = omniauth.except('extra')
        session[:omniauth] = omniauth
				redirect_to new_user_registration_url
      end
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
=begin
Also note that if you're already logged in, connecting to a facebook user won't save the token without making sure the authentication object is created with a token in the authentications controller:

if authentication
flash[:notice] = "Signed in successfully."
sign_in_and_redirect(:user, authentication.user)
elsif current_user
current_user.apply_omniauth!(omniauth)
flash[:notice] = "Authentication successful."
redirect_to authentications_url

where you can define apply_omniauth as:

def apply_omniauth(omniauth, save_it = false)
case omniauth['provider']
when 'facebook'
self.apply_facebook(omniauth)
end
self.email = omniauth['user_info']['email'] if email.blank?
build_authentications(omniauth, save_it)
end

def build_authentications(omniauth, save_it = false)
auth_params = {:provider => omniauth['provider'], :uid => omniauth['uid'], :token =>(omniauth['credentials']['token'] rescue nil)}
if save_it
authentications.create!(auth_params)
else
authentications.build(auth_params)
end
end

def apply_omniauth!(omniauth)
apply_omniauth(omniauth, true)
end
=end

