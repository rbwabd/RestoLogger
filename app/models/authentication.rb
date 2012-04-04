# == Schema Information
#
# Table name: authentications
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  token      :string(255)
#

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
