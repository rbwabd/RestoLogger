class Obfuscatable < ActiveRecord::Base
  self.abstract_class = true

  def id_encoded
    Hid.enc( self.id )
  end
  def to_param
    Hid.enc( self.id )
  end
end