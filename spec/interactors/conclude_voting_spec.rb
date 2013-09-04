require 'spec_helper'

describe ConcludeVoting do
  subject { described_class }

  describe ".perform" do
    context "user with membership being polled" do
      let(:membership) { create(:membership_being_polled, voting: voting) }
      let!(:user) { create(:user, membership: membership) }
      let(:params) { {user_id: user.id}.with_indifferent_access }

      context "voting passes" do
        let(:voting) { create(:passing_voting) }

        it "changes membership state to approved" do
          expect do
            subject.perform(params)
          end.to change { membership.reload.state }.from('being_polled').to('approved')
        end

        it "deactivates voting" do
          expect { subject.perform(params) }.to change{voting.reload.active}.from(true).to(false)
        end
      end

      context "voting does not pass" do
        let(:voting) { create(:not_passing_voting) }

        it "changes membership state to disapproved" do
          expect do
            subject.perform(params)
          end.to change { membership.reload.state }.from('being_polled').to('disapproved')
        end

        it "deactivates voting" do
          expect { subject.perform(params) }.to change{voting.reload.active}.from(true).to(false)
        end
      end
    end
  end
end
