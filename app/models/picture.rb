class Picture < ActiveRecord::Base
  #remote_image_url is handled by carrierwave - do not alter/delete! (allows to upload via an url rather than directly the file
  attr_accessible :genre, :image, :url, :remote_image_url

  belongs_to :user
  belongs_to :visit
  belongs_to :dish_review
  belongs_to :store
  
  mount_uploader :image, ImageUploader
  
  def initialize
    
  end
  
  #def image=(val)
  #  if !val.is_a?(String) && valid?
  #    image_will_change!
  #    super
  #  end
  #end

end
