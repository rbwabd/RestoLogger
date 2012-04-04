# == Schema Information
#
# Table name: user_settings
#
#  id           :integer         not null, primary key
#  locale       :string(255)
#  current_city :integer
#  user_id      :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

require 'spec_helper'

describe UserSetting do
  pending "add some examples to (or delete) #{__FILE__}"
end
