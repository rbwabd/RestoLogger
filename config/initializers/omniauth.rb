if Rails.env == "production"
	Rails.application.config.middleware.use OmniAuth::Builder do
		provider :facebook, '245402168879797', '460cfddb3c8dfb0bf70bc29c3a6676f6',{:scope => 'publish_stream,offline_access,email', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}   # Find these values on the Facebook App page
	end
else
	#if ENV['USER'] == 'monica'
		Rails.application.config.middleware.use OmniAuth::Builder do
			#provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
			provider :facebook, '245402168879797', '460cfddb3c8dfb0bf70bc29c3a6676f6', {:scope => 'publish_stream,offline_access,email'} # Find these values on the Facebook App page
		end
	#end
end