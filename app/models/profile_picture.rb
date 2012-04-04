# == Schema Information
#
# Table name: profile_pictures
#
#  id         :integer         not null, primary key
#  filename   :string(255)
#  image      :string(255)
#  url        :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class ProfilePicture < ActiveRecord::Base
  #remote_image_url is handled by carrierwave - do not alter/delete! (allows to upload via an url rather than directly the file
  attr_accessible :genre, :image, :url, :remote_image_url

  belongs_to :user
  
  mount_uploader :image, ProfileImageUploader
end
