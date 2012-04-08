source 'https://rubygems.org'

gem 'rails', '3.2.2'                  # main rails gem
gem 'jquery-rails'                    # jquery for rails
gem "pg"                              # posgresql database

# admin 
gem 'devise'                          # authentication package
gem 'omniauth'                        # external providers authentication integration 
gem 'omniauth-facebook'               # Facebook OAuth2 Strategy for OmniAuth 1.0.
gem 'cancan'                          # authorization package
gem 'activeadmin'                     # admin package
gem 'meta_search',    '>= 1.1.0.pre'  # required by active admin
gem 'paper_trail'                     # audit/versioning of records
  
# imaging
gem 'carrierwave'                     # image upload package
gem 'mini_magick'                     # image processing

# cloud 
gem 'fog'                             # used by carrierwave to upload images to remote cloud
gem 'aws-s3', :require => 'aws/s3'    # amazon S3 storage handling

# presentation
gem 'formtastic'                      # forms DSL package
gem 'gravatar_image_tag'              # gravatar profile images (2do: consider removing)
gem 'kaminari'                        # pagination package
#gem 'jquery-star-rating-rails'        # enable star ratings (not used so far)
gem 'datagrid'                        #sortable html tables

# miscellaneous
gem 'fb_graph'                        # allow to handle facebook graph

# Gems used only for assets and not required in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'      # sass css converter
  gem 'coffee-rails', '~> 3.2.1'      # coffeescript javascript converter
  gem 'uglifier', '>= 1.0.3'          # javascript compressor
  gem 'jquery-ui-rails'               # jquery-ui UI elements
end

group :development do
  gem 'rspec-rails', '2.6.1'          # runs test scenarios
  gem 'annotate', :git => 'git://github.com/jeremyolliver/annotate_models.git', :branch => 'rake_compatibility'                    # adds summary of current ActiveRecord schema to model rb file (run "bundle exec annotate -p before" to use)
  gem 'faker', '0.3.1'                # generates fake test data
end

group :test do
  gem 'rspec-rails', '2.6.1'          # runs test scenarios
  gem 'webrat', '0.7.1'               # acceptance test framework (allows you to access your application without a browser and to perform actions like clicking on a link or filling out forms) (check out also capybara)
  gem 'spork', '0.9.0.rc8'            # test server
  gem 'factory_girl_rails', '1.0'     # fixtures replacement 
  # gem 'autotest', '4.4.6'
  # gem 'autotest-rails-pure', '4.1.2'
  # gem 'autotest-fsevent', '0.2.4'
  # gem 'autotest-growl', '0.2.9'
end

group :production do
  # gems specifically for Heroku go here
  # gem 'thin'                        # better webserver in production than webrick
  # gem 'admin_data', '>= 1.1.16'     # allows to see into production DB - unnecessary with active_admin
end

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'