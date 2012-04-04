class ApplicationController < ActionController::Base
  protect_from_forgery
	before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to admin_dashboard_path, :alert => exception.message
  end
	
  def set_locale
	  #I18n.locale = params[:locale] || I18n.default_locale
    I18n.locale = current_user.nil? ? I18n.default_locale : current_user.locale
	end

  def decode_id
    params[:id] = Hid::dec(params[:id]).to_s if params[:id]
  end
end
