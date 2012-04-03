# encoding: UTF-8
ActiveAdmin.register AdminUser do    
  menu :if => proc{ can?(:manage, AdminUser) }     
  controller.authorize_resource 
end 