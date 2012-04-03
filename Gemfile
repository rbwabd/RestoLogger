source 'https://rubygems.org'

gem 'rails', '3.2.2'                  # main rails gem
gem 'jquery-rails'                    # jquery for rails
gem "pg"                              # posgresql database

gem 'devise'                          # authentication package
gem 'omniauth'                        # external authentication integration 
gem 'omniauth-facebook'               # Facebook OAuth2 Strategy for OmniAuth 1.0.
gem 'cancan'                          # authorization package

gem 'carrierwave'                     # image upload package
gem 'fog'                             # used by carrierwave to upload images to remote cloud
gem 'mini_magick'                     # image processing
gem 'aws-s3', :require => 'aws/s3'    # amazon S3 storage handling

gem 'gravatar_image_tag'              # gravatar profile images (2do: consider removing)
gem 'fb_graph'                        # allow to handle facebook graph
gem 'will_paginate'                   # pagination package
#gem 'jquery-star-rating-rails'        # enable star ratings (not used so far)

# Gems used only for assets and not required in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'      # sass css converter
  gem 'coffee-rails', '~> 3.2.1'      # coffeescript javascript converter
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-ui-rails'               # jquery-ui UI elements
end

group :development do
  gem 'rspec-rails', '2.6.1'
  gem 'annotate', '2.4.0'
  gem 'faker', '0.3.1'
end

group :test do
  gem 'rspec-rails', '2.6.1'
  gem 'webrat', '0.7.1'
  gem 'spork', '0.9.0.rc8'
  gem 'factory_girl_rails', '1.0'
  # gem 'autotest', '4.4.6'
  # gem 'autotest-rails-pure', '4.1.2'
  # gem 'autotest-fsevent', '0.2.4'
  # gem 'autotest-growl', '0.2.9'
end

group :production do
  # gems specifically for Heroku go here
  # gem 'thin'
  gem 'admin_data', '>= 1.1.16'      # allows to see into production DB
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'