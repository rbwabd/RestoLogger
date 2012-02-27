require 'spec_helper'

describe VisitsController do
  render_views

  describe "access control" do
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end
  
  describe "POST 'create'" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end

    describe "failure" do

      before(:each) do
        @attr = { :content => "" }
      end

      it "should not create a visit" do
        lambda do
          post :create, :visit => @attr
        end.should_not change(Visit, :count)
      end
      
      it "should re-render the home page" do
        post :create, :visit => @attr
        response.should render_template('pages/home')
      end
    end

    describe "success" do
      
      before(:each) do
        @attr = { :content => "Lorem ipsum dolor sit amet" }
      end
      
      it "should create a visit" do
        lambda do
          post :create, :visit => @attr
        end.should change(Visit, :count).by(1)
      end
      
      it "should redirect to the root path" do
        post :create, :visit => @attr
        response.should redirect_to(root_path)
      end

      it "should have a flash success message" do
        post :create, :visit => @attr
        flash[:success].should =~ /visit created/i
      end
    end
  end

  describe "DELETE 'destroy'" do

    describe "for an unauthorized user" do
      
      before(:each) do
        @user = Factory(:user)
        wrong_user = Factory(:user, :email => Factory.next(:email))
        @visit = Factory(:visit, :user => @user)
        test_sign_in(wrong_user)
      end

      it "should deny access" do
        delete :destroy, :id => @visit
        response.should redirect_to(root_path)
      end
    end
    
    describe "for an authorized user" do
      
      before(:each) do
        @user = test_sign_in(Factory(:user))
        @visit = Factory(:visit, :user => @user)
      end
      
      it "should destroy the visit" do
        lambda do
          delete :destroy, :id => @visit
          flash[:success].should =~ /deleted/i
          response.should redirect_to(root_path)
        end.should change(Visit, :count).by(-1)
      end
    end
  end
end