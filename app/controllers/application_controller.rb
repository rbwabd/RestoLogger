class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
	
#  protected	
#		def after_sign_in_path_for(resource)
#			path = ''
#			if session[:next]
#				path = session[:next]
#				session[:next] = nil
#			else
#				path = super
#			end
#
#			path
#		end
	 
#		def after_sign_out_path_for(user)
#			root_url(:subdomain => false)
#		end		
end
