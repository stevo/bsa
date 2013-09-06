require 'spec_helper'

describe Admin::User::RightsController do
  include_context 'logged in as admin'
  include_context 'some user exists'

  describe "PUT #update" do
    let!(:role) { create(:role, name: 'some_role') }
    let(:call_request) { put :update, user_id: some_user.id, user: {role_ids: role.id} }

    it do
      expect { call_request }.to change { some_user.reload.has_role?(:some_role) }.from(false).to(true)
    end

    context 'after_request' do
      before { call_request }
      it { expect(response).to redirect_to admin_users_path }
    end
  end
end
