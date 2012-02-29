class Picture < ActiveRecord::Base
  #remote_image_url is handled by carrierwave - do not alter/delete! (allows to upload via an url rather than directly the file
  attr_accessible :genre, :image, :remote_image_url

  mount_uploader :image, ImageUploader
end
