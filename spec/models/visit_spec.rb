# == Schema Information
#
# Table name: visits
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  overall_rating  :integer
#  service_rating  :integer
#  speed_rating    :integer
#  mood_rating     :integer
#  tagline         :string(255)
#  review          :text
#  guest_number    :integer
#  city_id         :integer
#  store_id        :integer
#  visit_date      :date
#  spend           :float
#  perimated       :integer
#  value_rating    :integer
#  visibility_mask :integer
#  private_comment :string(255)
#

require 'spec_helper'

describe Visit do

  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "lorem ipsum" }
  end
  
  it "should create a new instance with valid attributes" do
    @user.visits.create!(@attr)
  end
  
  describe "user associations" do
    
    before(:each) do
      @visit = @user.visits.create(@attr)
    end
    
    it "should have a user attribute" do
      @visit.should respond_to(:user)
    end
    
    it "should have the right associated user" do
      @visit.user_id.should == @user.id
      @visit.user.should == @user
    end
  end
  
  describe "validations" do

    it "should have a user id" do
      Visit.new(@attr).should_not be_valid
    end

    it "should require nonblank content" do
      @user.visits.build(:content => "    ").should_not be_valid
    end
    
    it "should reject long content" do
      @user.visits.build(:content => "a" * 141).should_not be_valid
    end
  end

  describe "from_users_followed_by" do
    
    before(:each) do
      @other_user = Factory(:user, :email => Factory.next(:email))
      @third_user = Factory(:user, :email => Factory.next(:email))
      
      @user_post  = @user.visits.create!(:content => "foo")
      @other_post = @other_user.visits.create!(:content => "bar")
      @third_post = @third_user.visits.create!(:content => "baz")
      
      @user.follow!(@other_user)
    end
    
    it "should have a from_users_followed_by method" do
      Visit.should respond_to(:from_users_followed_by)
    end
    
    it "should include the followed user's visits" do
      Visit.from_users_followed_by(@user).should include(@other_post)
    end
    
    it "should include the user's own visits" do
      Visit.from_users_followed_by(@user).should include(@user_post)
    end
    
    it "should not include an unfollowed user's visits" do
      Visit.from_users_followed_by(@user).should_not include(@third_post)
    end
  end
end
