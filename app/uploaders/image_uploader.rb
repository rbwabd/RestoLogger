# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  #storage :fog

  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    "uploads/#{model.class.to_s.underscore}"
  end

  version :thumb do
    process :resize_to_fill => [300, 200]
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  #def filename
  #  "something.jpg" if if original_filename
  #end
  
  # fix for Heroku, unfortunately, it disables caching, 
  # see: https://github.com/jnicklas/carrierwave/wiki/How-to%3A-Make-Carrierwave-work-on-Heroku
  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end
end
