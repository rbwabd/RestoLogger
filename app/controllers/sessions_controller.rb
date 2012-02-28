class SessionsController < Devise::SessionsController
  
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
			#this is when user is logged in but is adding another authentication method
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
			  #this part needs to be rewritten...
        #could result in cookie-overflow due to exceeding 4k size in session - better use session[:omniauth] = omniauth.except('extra')
				#session[:omniauth] = omniauth
				redirect_to new_user_registration_url
      end
    end
  end
  
  def destroy
    sign_out
		flash[:notice] = "Sign out successful."
    redirect_to root_path
  end
end