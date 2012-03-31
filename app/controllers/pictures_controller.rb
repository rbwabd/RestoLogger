class PicturesController < ApplicationController
  def destroy
    @picture = Picture.find(params[:id])
    #AWS::S3::S3Object.find(@picture.filename, @@BUCKET).delete
    @picture.destroy
    flash[:notice] = "Successfully destroyed picture."
    redirect_to root_path
  end
end
