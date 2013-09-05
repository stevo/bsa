require 'spec_helper'

describe User::MembershipController do
  include_context 'logged in as user'

  describe "POST 'create'" do
    it "redirects to dashboard" do
      post :create
      expect(response).to redirect_to(root_path)
    end

    it "creates new membership for current user" do
      expect { post :create }.to change { user.reload.membership }.from(nil)
    end

    context "user already has membership" do
      before { create(:membership, user: user)}

      it "redirects to dashboard" do
        post :create
        expect(response).to redirect_to(root_path)
      end

      it "does not create new membership for current user" do
        expect { post :create }.to_not change { user.reload.membership }
      end
    end
  end
end
