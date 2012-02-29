class PicturesController < ApplicationController

  @@BUCKET = "resto-tester"

  def new
    @picture = Picture.new(params[:picture])
  end

  def create
=begin
    fileUp = params[:upload]
	  orig_filename =  fileUp['datafile'].original_filename
	  filename = orig_filename #sanitize_file_name(orig_filename)
    #AWS::S3::Base.establish_connection!(
    #  :access_key_id     => 'AKIAJ5MS5WRS5BWUKKEA',
    #  :secret_access_key => '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'
    #)

	  AWS::S3::S3Object.store(filename, fileUp['datafile'].read, @@BUCKET, :access => :public_read)
	  url = AWS::S3::S3Object.url_for(filename, @@BUCKET, :authenticated => false)
    @picture = Picture.new(params[:picture])
	  #@image.user = current_user
	  @image.filename = filename
	  @image.url = url;
	  if @image.save
	    flash[:success] = "Image saved! "
      redirect_to root_path
	  else
      render :action => 'new'
	  end
=end

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
    #AWS::S3::S3Object.find(@picture.filename, @@BUCKET).delete
    @picture.destroy
    flash[:notice] = "Successfully destroyed picture."
    redirect_to root_path
  end

  #should be moved into a helper?
  private
    def sanitize_file_name (fname)
      fname.gsub(/[^A-Za-z0-9\.\-]/, '_')
    end  
end
