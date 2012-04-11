class SessionsController < Devise::SessionsController
  # This controller should not need authentication / authorization
  
  def create
		omniauth = request.env["omniauth.auth"]

		#if right authentication found in DB, automatically refresh the token
		authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])#.tap do |a|
    #  a.update_attributes(:token => omniauth["credentials"]["token"]) if a
    #end
    
		if authentication && authentication.user.present?
      flash[:notice] = "Signed in successfully."
      authentication.user.check_update_profile_picture(omniauth)
      sign_in_and_redirect(:user, authentication.user)  #devise method call
    elsif current_user
			#this is when user is logged in but is adding another authentication method
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth["credentials"]["token"])
      current_user.check_update_profile_picture(omniauth)
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      user = User.new
      #the below also creates a new authentication object in DB
      user.apply_omniauth(omniauth)
      user.init_routine
      user.update_profile_picture(omniauth)

			if user.save
        # update the friends connections in relationships table
        user.load_fb_friends(omniauth["credentials"]["token"])
        
        flash[:notice] = "Signed in new user successfully."
				sign_in_and_redirect(:user, user)
			else
			  #2do: this part needs to be rewritten...
       
        #next statementcould result in cookie-overflow due to exceeding 4k size in session - better use session[:omniauth] = omniauth.except('extra')
				#session[:omniauth] = omniauth
        #could be because DB got corrupted and there are orphan authentications without allocated user (but user was recreated with new authentication
        flash[:error] = "Save of new user failed"
				redirect_to new_user_registration_url
      end
    end
  end
  
  def destroy
    sign_out
    I18n.locale = "en"
    flash[:notice] = "Sign out successful."
    redirect_to root_path
  end

end