class Authentication < ActiveRecord::Base
  belongs_to :user
  
  def provider_name
    if provider == 'open_id'
      "OpenID"
    else
      provider.titleize
    end
  end
  
  def id_encoded
    Hid.enc( self.id )
  end
  
  def to_param
    Hid.enc( self.id )
  end 
end
