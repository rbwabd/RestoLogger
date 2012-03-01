class State < ActiveRecord::Base
  attr_accessible :name
  
  has_many :cities 
  belongs_to :country
end
