# == Schema Information
#
# Table name: store_lists
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class StoreList < Obfuscatable
  attr_accessible :id, :name, :user_id
  
  after_initialize :init_routine
  
  belongs_to :user
  has_many :store_list_entries,  :dependent => :destroy
  has_many :stores, :through => :store_list_entries

  accepts_nested_attributes_for :store_list_entries
  
  scope :with_visibility, lambda { |visibility| {:conditions => "visibility_mask & #{2**VISIBILITIES.index(visibility.to_s)} > 0 "} }
  # so 1 = all 2 = friends, 4 = me
  VISIBILITIES = %w[all friends me]
  def visibilities=(visibilities)
    self.visibility_mask = (visibilities & VISIBILITIES).map { |r| 2**VISIBILITIES.index(r) }.sum
  end
  def visibilities
    VISIBILITIES.reject { |r| ((visibility_mask || 0) & 2**VISIBILITIES.index(r)).zero? }
  end
  def visibility?(visibility)
    visibilities.include? visibility.to_s
  end

  private 
    def init_routine
      #set visibility to 'all'
      self.visibility_mask = 1;
    end  
end
