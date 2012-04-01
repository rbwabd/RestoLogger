class Picture < ActiveRecord::Base
  #remote_image_url is handled by carrierwave - do not alter/delete! (allows to upload via an url rather than directly the file
  attr_accessible :genre, :image, :url, :remote_image_url

  belongs_to :user
  belongs_to :visit
  belongs_to :dish_review
  belongs_to :store
  
  mount_uploader :image, ImageUploader
  
  def id_encoded
    Hid.enc( self.id )
  end
  def to_param
    Hid.enc( self.id )
  end  
end
