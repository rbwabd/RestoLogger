# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  #this sorta works but had to disable the pic.image? test... seems to be ok...
  after :store, :delete_original_file

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  #storage :file
  storage :fog

  def store_dir
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    "uploads/#{model.class.to_s.underscore}"
  end

  version :full do
    process :resize_to_fit => [800, 800]
  end

  version :thumb do
    process :resize_to_fit => [250, 250]
  end
  
  version :mini do
    process :resize_to_fit => [85, 85]
  end
  
  def delete_original_file(new_file)
    File.delete path if version_name.blank?
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
