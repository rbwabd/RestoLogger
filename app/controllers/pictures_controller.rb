class PicturesController < ApplicationController
  before_filter :decode_id
  load_and_authorize_resource 
  
=begin
  def destroy
    #AWS::S3::S3Object.find(@picture.filename, @@BUCKET).delete
    @picture.destroy
    redirect_to root_path
  end 
=end  
end
