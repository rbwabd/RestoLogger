# == Schema Information
#
# Table name: dish_reviews
#
#  id         :integer         not null, primary key
#  rating     :integer
#  tagline    :string(255)
#  review     :text
#  dish_id    :integer
#  user_id    :integer
#  visit_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  quantity   :integer
#  perimated  :integer
#  rank       :integer
#

class DishReview < ActiveRecord::Base
  attr_accessible :user_id, :dish_id, :rating, :tagline, :review, :dish

  after_initialize :init_routine
  
  belongs_to :user
  belongs_to :visit
  belongs_to :dish
  
  has_many :pictures, :dependent => :destroy

  has_paper_trail

  def id_encoded
    Hid.enc( self.id )
  end
  def to_param
    Hid.enc( self.id )
  end

  private 
    def init_routine
      #set visibility to 'all'
      self.visibility_mask = 1;
    end
end
