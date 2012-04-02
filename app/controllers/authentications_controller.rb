class AuthenticationsController < ApplicationController
  before_filter :decode_id
  load_and_authorize_resource 
  
  def index
		@title = "authentications.sign_in_title"
  end
  
  def destroy
    @authentication.destroy
    flash[:notice] = I18n.t("authentications.destroy_success_message")
    #redirect_to authentications_url
    redirect_to authentications_path
  end
end
