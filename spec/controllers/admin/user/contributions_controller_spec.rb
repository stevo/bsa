require 'spec_helper'

describe Admin::User::ContributionsController do
  include_context 'logged in as admin'
  include_context 'some user exists'

  context 'contribution for user given exists' do
    let!(:contribution) { create(:contribution, user: some_user) }

    describe 'GET #new' do
      let(:call_request) { get :new, user_id: some_user.id }

      context 'after_request' do
        before { call_request }

        it { expect(response).to render_template "new" }
        it { expect(response).to be_success }
      end
    end

    describe 'POST #create' do
      before { request.env["HTTP_REFERER"] = "where_i_came_from" }
      let(:contribution_amount){ 10 }
      let(:call_request) { post :create, user_id: some_user.id, contribution: {amount: contribution_amount} }

      it { expect { call_request }.to change { some_user.reload.contributions.count }.by(1) }

      context 'after_request' do
        before { call_request }

        it { expect(some_user.contributions.last.amount).to eq contribution_amount }
        it { expect(response).to redirect_to "where_i_came_from"  }
      end
    end

    describe 'DELETE #destroy' do
      before { request.env["HTTP_REFERER"] = "where_i_came_from" }
      let(:call_request) { delete :destroy, user_id: some_user.id, id: contribution.id }

      it { expect { call_request }.to change { some_user.reload.contributions.count }.by(-1) }

      context 'after_request' do
        before { call_request }

        it { expect(response).to redirect_to "where_i_came_from"  }
      end
    end
  end
end
