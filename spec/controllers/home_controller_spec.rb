require 'spec_helper'

describe User::DashboardController do
  include_context 'logged in as user'

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end
end
