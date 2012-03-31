class SessionsController < Devise::SessionsController
  
  def create
		omniauth = request.env["omniauth.auth"]

		#if right authentication found in DB, automatically refresh the token
		authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])#.tap do |a|
    #  a.update_attributes(:token => omniauth["credentials"]["token"]) if a
    #end
    
		if authentication && authentication.user.present?
			session[:user_id] = authentication.user.id 
      check_updated_profilepic(authentication.user, omniauth)
			flash[:notice] = "Signed in successfully."
			#this is a devise method
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
			session[:user_id] = current_user.id 
			#this is when user is logged in but is adding another authentication method
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth["credentials"]["token"])
      check_updated_profilepic(current_user, omniauth)
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      user = User.new
      #the below also creates a new authentication object in DB
      user.apply_omniauth(omniauth)
      user.profilepicurl=set_user_profilepic(omniauth)
      session[:user_id] = user.id 
			if user.save
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
    I18n.locale="en"
    flash[:notice] = "Sign out successful."
    redirect_to root_path
  end
  
  private
    #check whether profile pic url for user exists, if not update through omniauth
    def check_updated_profilepic(user, omniauth)
      if user.profilepicurl.nil? then 
        user.profilepicurl=set_user_profilepic(omniauth)
        if !user.save
          flash[:error] = "Profile Picture update failed!"
        end
      end
    end
  
    # gets remote profile pic, uploads to AWS and puts url into user table
    def set_user_profilepic(omniauth)
      case omniauth['provider']
      when 'facebook'
        fb_user = FbGraph::User.me(omniauth["credentials"]["token"]).fetch
        picture = ProfilePicture.new()
        picture.remote_image_url=fb_user.picture
        picture.save
        return picture.image_url
      end
    end
end