class Picture < ActiveRecord::Base
  attr_accessible :genre, :image

  mount_uploader :image, ImageUploader
end
