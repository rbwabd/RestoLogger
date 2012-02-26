class SessionsController < Devise::SessionsController

  def new
    @title = "Sign in"
  end
  
  def create
		omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication && authentication.user.present?
      flash[:notice] = "Signed in successfully."
			#this is a devise method
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to authentications_url
    else
      user = User.new
			#the below also creates a new authentication object in DB
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in new user successfully."
				sign_in_and_redirect(:user, user)
			else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
