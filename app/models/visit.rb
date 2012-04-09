# == Schema Information
#
# Table name: visits
#
#  id             :integer         not null, primary key
#  user_id        :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  overall_rating :integer
#  service_rating :integer
#  speed_rating   :integer
#  mood_rating    :integer
#  tagline        :string(255)
#  review         :text
#  guest_number   :integer
#  city_id        :integer
#  store_id       :integer
#  visit_date     :date
#  spend          :float
#  perimated      :integer
#  value_rating   :integer
#

class Visit < Hideable
  attr_accessor :city_name, :store_name
  attr_accessible :city_name, :store_name, :visit_date
  
  belongs_to :user
  belongs_to :store
  belongs_to :city
  has_many :dish_reviews, :autosave => true, :dependent => :destroy
  has_many :pictures,     :dependent => :destroy

  #validates :content, :presence => true, :length => { :maximum => 140 }
  #validates :user_id, :presence => true
  
  has_paper_trail

  default_scope :order => 'visit_date DESC'
  
  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private 
    def self.followed_by(user)
      following_ids = %(SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id)
      where("user_id IN (#{following_ids}) OR user_id = :user_id",
            :user_id => user)
    end
end
