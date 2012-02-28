class RelationshipsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
		#in respond_to only one of the two lines gets executed!
		#In the case of an Ajax request, Rails automatically calls a JavaScript Embedded Ruby (.js.erb) file with the same name as the action, i.e., create.js.erb or destroy.js.erb.
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end