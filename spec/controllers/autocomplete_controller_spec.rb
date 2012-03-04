require 'spec_helper'

describe AutocompleteController do

  describe "GET 'cities'" do
    it "should be successful" do
      get 'cities'
      response.should be_success
    end
  end

end
