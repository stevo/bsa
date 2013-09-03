require 'spec_helper'

describe Admin::UsersController do
  include_context 'logged in as user'

  describe "GET 'show'" do

    it "should be successful" do
      get :show, id: user.id
      response.should be_success
    end

    it "should find the right user" do
      get :show, id: user.id
      expect(subject.user).should == user
    end
  end
end
