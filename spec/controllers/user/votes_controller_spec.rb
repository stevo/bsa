require 'spec_helper'

describe User::VotesController do
  include_context 'logged in as user'

  describe "POST 'create'" do
    context "voting exists" do
      let!(:voting) { create(:voting) }

      it "creates new vote for voting" do
        expect do
          post :create, voting_id: voting.id, vote: {state: 'for'}
        end.to change { voting.reload.votes.count }.by(1)
      end

      context "after request" do
        before { post :create, voting_id: voting.id, vote: {state: 'for'} }
        let(:last_vote){ voting.votes.last }

        it "redirects to dashboard" do
          expect(response).to redirect_to(root_path)
        end

        it "vote is assigned to current user" do
         expect(last_vote.voter).to eq user
        end

        it "vote has proper state" do
          expect(last_vote.state).to eq 'for'
        end

        context "voting again for same person" do
          it "does not create new vote for voting" do
            expect do
              post :create, voting_id: voting.id, vote: {state: 'for'}
            end.to_not change { voting.reload.votes.count }.by(1)
          end
        end
      end
    end
  end
end
