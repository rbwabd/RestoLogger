class UsersController < ApplicationController
  #run these methods before the specific actions (e.g. edit)
	#before_filter :authenticate_user!#, :only => [:edit, :update]
	#before_filter :correct_user, :only => [:edit, :update]
  #before_filter :admin_user,   :only => :destroy
  
  def index
    @title = "users.index_title"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @title = @user.name #2do: fix that can just show in view
    @user = User.find_by_zid(params[:id])
  end
=begin
  #think this code is directly from the tutorial book and doens't work here...
  def following
    @title = "users.following"
    @user = User.find_by_zid(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "users.followers"
    @user = User.find_by_zid(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  
  def new
    @title = "users.new_title"
    @button = "users.new_button"
    @user  = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, :flash => { :success => "Welcome to RestoLogger!" }
    else
      @title = "users.new_title"
      @button = "users.new_button"
      render 'new'
    end
  end
=end  
  def edit
    @title = "users.edit_title"
    @button = "users.edit_button"
    #need to set user_setting so the form knows how to initialize the field
    #@user = User.get_by_zid(params[:id])
    @user_setting = @user.user_setting
  end
  
  def update
    @user = User.get_by_zid(params[:id])
    if @user.update_attributes(params[:user]) && @user.user_setting.update_attributes(params[:user_setting])
      redirect_to user_path(user.zid), :flash => { :success => "Profile updated." }
    else
      @title = "users.edit_title"
      @button = "users.edit_button"
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, :flash => { :success => "User destroyed." }
  end

  private
=begin
  #from rails tutorial
    def correct_user
      @user = User.find_by_zid(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      @user = User.find_by_zid(params[:id])
      redirect_to(root_path) if !current_user.admin? || current_user?(@user)
    end
=end    
end
