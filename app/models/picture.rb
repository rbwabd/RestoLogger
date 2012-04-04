# == Schema Information
#
# Table name: pictures
#
#  id             :integer         not null, primary key
#  genre          :string(255)
#  filename       :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  image          :string(255)
#  url            :string(255)
#  tagline        :string(255)
#  description    :string(255)
#  user_id        :integer
#  visit_id       :integer
#  dish_review_id :integer
#  store_id       :integer
#  vote_count     :integer
#  perimated      :integer
#  rank           :integer
#

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
