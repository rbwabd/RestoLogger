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

class Visit < Obfuscatable
  attr_accessor :city_name, :store_name
  attr_accessible :city_name, :store_name, :visit_date

  after_initialize :init_routine
  
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
  
    def self.followed_by(user)
      following_ids = %(SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id)
      where("user_id IN (#{following_ids}) OR user_id = :user_id",
            :user_id => user)
    end
end
