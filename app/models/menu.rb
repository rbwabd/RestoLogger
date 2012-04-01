class Menu < ActiveRecord::Base

  def id_encoded
    Hid.enc( self.id )
  end
  def to_param
    Hid.enc( self.id )
  end
end
