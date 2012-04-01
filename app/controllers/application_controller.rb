class ApplicationController < ActionController::Base
  protect_from_forgery
	
	before_filter :set_locale
	
  def set_locale
	  #I18n.locale = params[:locale] || I18n.default_locale
    I18n.locale = current_user.nil? ? I18n.default_locale : current_user.locale
	end

  # decode the id url param if there is one
  def decode_id
    params[:id] = IdCrypt::decode_id(params[:id]).to_s if params[:id]
  end
end
