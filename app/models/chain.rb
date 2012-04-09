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

class Chain < Obfuscatable

  has_paper_trail

end
