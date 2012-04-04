# == Schema Information
#
# Table name: chains
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  shortname  :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Chain < ActiveRecord::Base

  #has_paper_trail
  
  def id_encoded
    Hid.enc( self.id )
  end
  def to_param
    Hid.enc( self.id )
  end

end
