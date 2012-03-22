class ProfilePicture < ActiveRecord::Base
  #remote_image_url is handled by carrierwave - do not alter/delete! (allows to upload via an url rather than directly the file
  attr_accessible :genre, :image, :url, :remote_image_url

  belongs_to :user
  
  mount_uploader :image, ProfileImageUploader
end
