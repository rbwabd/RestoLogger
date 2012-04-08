class UsersController < ApplicationController
  before_filter :decode_id
	before_filter :authenticate_user!
	load_and_authorize_resource
  
  def index
    @users = @users.page(params[:page]).per(20)
  end
  
  def show
  end

  def edit
    @user_setting = @user.user_setting
  end
  
  def update
    if @user.update_attributes(params[:user]) && @user.user_setting.update_attributes(params[:user_setting])
      redirect_to user_path(@user), :flash => { :success => "Profile updated." }
    else
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
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def followers
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  def new
    @user  = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      redirect_to @user, :flash => { :success => "Welcome to RestoLogger!" }
    else
      render 'new'
    end
  end
=end  

end
