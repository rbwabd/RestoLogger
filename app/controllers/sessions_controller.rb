class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end
  
  def create
		auth = request.env["omniauth.auth"]  
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)  
		session[:user_id] = user.id  
    redirect_to root_url, :notice => "Signed in!"
=begin
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      redirect_back_or user
    end
=end		
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
