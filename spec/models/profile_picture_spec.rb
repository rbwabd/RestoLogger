# == Schema Information
#
# Table name: profile_pictures
#
#  id         :integer         not null, primary key
#  filename   :string(255)
#  image      :string(255)
#  url        :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe ProfilePicture do
  pending "add some examples to (or delete) #{__FILE__}"
end
