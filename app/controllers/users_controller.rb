class UsersController < ApplicationController
  #run these methods before the specific actions (e.g. edit)
	before_filter :authenticate_user!#, :only => [:edit, :update]
	before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index
    @title = "index_title"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @visits = @user.visits.paginate(:page => params[:page])
    @title = @user.name
  end

  def following
    @title = "following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  def new
    @user  = User.new
    @title = "new_title"
    @button = "new_button"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, :flash => { :success => "Welcome to the Sample App!" }
    else
      @title = "new_title"
      @button = "new_button"
      render 'new'
    end
  end
  
  def edit
    @title = "edit_title"
    @button = "edit_button"
    #need to set user_setting so the form knows how to initialize the field
    @user_setting = @user.user_setting
  end
  
  def update
    if @user.update_attributes(params[:user]) && @user.user_setting.update_attributes(params[:user_setting])
      redirect_to @user, :flash => { :success => "Profile updated." }
    else
      @title = "edit_title"
      @button = "edit_button"
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, :flash => { :success => "User destroyed." }
  end

  private
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_path) if !current_user.admin? || current_user?(@user)
    end
end
