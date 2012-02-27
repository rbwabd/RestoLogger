if Rails.env == "production"
	Rails.application.config.middleware.use OmniAuth::Builder do
		provider :facebook, '245402168879797', '460cfddb3c8dfb0bf70bc29c3a6676f6',{:scope => 'publish_stream,offline_access,email', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}}   
	end
else
	#if ENV['USER'] == 'monica'
		Rails.application.config.middleware.use OmniAuth::Builder do
			#provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
			provider :facebook, '242516295838836', '5eea597f7b47e15da107328196f8e047', {:scope => 'publish_stream,offline_access,email'} 
		end
	#end
end