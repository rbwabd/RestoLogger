# == Schema Information
#
# Table name: store_types
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class StoreType < ActiveRecord::Base
end
