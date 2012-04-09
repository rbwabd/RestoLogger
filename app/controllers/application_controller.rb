class ApplicationController < ActionController::Base
  protect_from_forgery
	before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_dashboard_path, :alert => exception.message
  end
	
  # don't think this is necessary?
  #def user_for_paper_trail
  #  user_signed_in? ? current_user : 'Unknown user'
  #end
  
  def set_locale
	  #I18n.locale = params[:locale] || I18n.default_locale
    I18n.locale = (current_user.nil? || current_user.user_setting.nil?) ? I18n.default_locale : current_user.locale
	end

  def decode_id
    params[:id] = Hid::dec(params[:id]).to_s if params[:id]
  end
end
