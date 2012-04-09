# == Schema Information
#
# Table name: store_lists
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  name            :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  visibility_mask :integer
#

class StoreList < Hideable
  after_initialize :init_routine

  attr_accessible :id, :name, :user_id
  
  belongs_to :user
  has_many :store_list_entries,  :dependent => :destroy
  has_many :stores, :through => :store_list_entries

  #2do: can remove following line once i move away from formtastic
  accepts_nested_attributes_for :store_list_entries

  private 
    def init_routine
      #set visibility to 'all'
      self.visibility_mask = 1;
    end  
end
