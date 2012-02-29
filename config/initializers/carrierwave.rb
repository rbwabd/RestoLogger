CarrierWave.configure do |config|
  config.cache_dir = 'carrierwave'
  config.fog_credentials = {
    :provider               => 'AWS',       # required
    :aws_access_key_id      => 'AKIAJ5MS5WRS5BWUKKEA',       # required
    :aws_secret_access_key  => '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',       # required
    #:region                 => 'eu-west-1'  # optional, defaults to 'us-east-1'
  }
  config.permissions = 0777 
  config.fog_directory  = 'resto-tester'                     # bucket name - required
  #config.fog_host       = 'https://assets.example.com'            # optional, defaults to nil
  #config.fog_public     = false                                   # optional, defaults to true
  #config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
  #needed for windows local tests as trying to delete temp file causes a eaccess error/permission denied
  if ENV['RAILS_ENV'] != 'production'
    config.delete_tmp_file_after_storage = false
  end
end