class PicturesController < ApplicationController
  def new
    @picture = Picture.new(params[:picture])
  end

  def create
    @picture = Picture.new(params[:picture])
    if @picture.save
      flash[:notice] = "Successfully created picture."
      redirect_to @picture
    else
      render :action => 'new'
    end
  end

  def edit
    @picture = Picture.find(params[:id])
  end

  def update
    @picture = Picture.find(params[:id])
    if @picture.update_attributes(params[:picture])
      flash[:notice] = "Successfully updated picture."
      redirect_to @picture
    else
      render :action => 'edit'
    end
  end
  
  def show
    @picture = Picture.find(params[:id])
    @title = @picture.genre
  end


  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
    flash[:notice] = "Successfully destroyed picture."
    redirect_to root_path
  end

end
