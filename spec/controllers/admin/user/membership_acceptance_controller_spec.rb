require 'spec_helper'

describe Admin::User::MembershipAcceptanceController do
  include_context 'logged in as admin'

  context 'POST #create' do
    context 'candidate exists' do
      let!(:candidate) { create(:user, :new_membership) }
      let(:request_call){ post :create, user_id: candidate.id }

      it 'succeeds voting' do
        SucceedVoting.should_receive(:perform).with('user_id' => candidate.id.to_s)
        request_call
      end

      context 'after_request' do
        before { request_call }

        it { expect(response).to redirect_to admin_users_path }
      end
    end
  end
end
