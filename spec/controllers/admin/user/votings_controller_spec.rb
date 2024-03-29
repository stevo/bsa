require 'spec_helper'

describe Admin::User::VotingsController do
  include_context 'logged in as admin'

  context 'POST #create' do
    context 'candidate exists' do
      let!(:candidate) { create(:user, :new_membership) }
      let!(:interactor) { double }

      it 'starts voting' do
        StartVoting.should_receive(:new).with(controller).and_return(interactor)
        interactor.should_receive(:perform)
        post :create, user_id: candidate.id
      end

      context 'after_request' do
        before { post :create, user_id: candidate.id }

        it { expect(response).to redirect_to admin_users_path }
      end
    end
  end

  context 'PUT #update' do
    context 'candidate being polled exists' do
      let(:voting) { create(:voting, :active) }
      let(:membership) { create(:membership_being_polled, voting: voting) }
      let!(:candidate) { create(:user, membership: membership) }
      let(:call_request) { put :update, user_id: candidate.id, id: voting.id }
      let!(:interactor) { double }

      it 'concludes voting' do
        ConcludeVoting.should_receive(:new).with(controller).and_return(interactor)
        interactor.should_receive(:perform)
        call_request
      end

      context 'after_request' do
        before { call_request }
        it { expect(response).to redirect_to admin_users_path }
      end
    end
  end
end
