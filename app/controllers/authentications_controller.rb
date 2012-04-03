class AuthenticationsController < ApplicationController
  before_filter :decode_id
  load_and_authorize_resource 
  
  def index
		@title = "authentications.sign_in_title"
    @authentications ||= Array.new # if we can't access anything load_resource returns nil. If user account is created outside of external auth this can be true
  end
  
  def destroy
    @authentication.destroy
    flash[:notice] = I18n.t("authentications.destroy_success_message")
    #redirect_to authentications_url
    redirect_to authentications_path
  end
end
