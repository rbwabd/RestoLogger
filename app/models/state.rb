# == Schema Information
#
# Table name: states
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  country_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class State < ActiveRecord::Base
  attr_accessible :name, :country_id
  
  has_many :cities 
  belongs_to :country
end
