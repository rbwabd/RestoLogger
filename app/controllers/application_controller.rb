class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
	
	before_filter :set_locale
	def set_locale
	  #I18n.locale = params[:locale] || I18n.default_locale
    I18n.locale = current_user.nil? ? I18n.default_locale : current_user.locale
	end
end
