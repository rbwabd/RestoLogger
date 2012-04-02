class UsersController < ApplicationController
  before_filter :decode_id
	before_filter :authenticate_user!
	load_and_authorize_resource
  
  def index
    @title = "users.index_title"
    @users = @users.paginate(:page => params[:page])
  end
  
  def show
    @title = @user.name 
  end

  def edit
    @title = "users.edit_title"
    @button = "users.edit_button"
    @user_setting = @user.user_setting
  end
  
  def update
    if @user.update_attributes(params[:user]) && @user.user_setting.update_attributes(params[:user_setting])
      redirect_to user_path(@user), :flash => { :success => "Profile updated." }
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
=begin
  #think this code is directly from the tutorial book and doens't work here...
  def following
    @title = "users.following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "users.followers"
    @user = User.find(params[:id])
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

end
