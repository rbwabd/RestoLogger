class UsersController < ApplicationController
  before_filter :decode_id
	before_filter :authenticate_user!
	load_and_authorize_resource :except => [:show_my_following, :update_friend_list]
  
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
  
  def show_my_following
    authorize! :show_my_following, User
    # nothing to load, data directly accessible in view
  end
  
  def update_friend_list
    authorize! :update_friend_list, User
    token = Authentication.where("provider = 'facebook' and user_id = ?", current_user.id).first.token
    current_user.load_fb_friends(token)
    redirect_to show_my_following_users_path, :flash => { :success => "Friends List Updated" }
  end
  
  
=begin
  #think this code is directly from the tutorial book and doesn't work here...
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
