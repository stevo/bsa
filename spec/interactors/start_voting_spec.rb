require 'spec_helper'

describe StartVoting do
  subject { described_class }

  describe ".perform" do
    context "user with membership" do
      let(:membership) { create(:membership) }
      let!(:user) { create(:user, membership: membership) }
      let(:params) { {user_id: user.id}.with_indifferent_access }

      it "creates new voting for membership" do
        expect { subject.perform(params) }.to change { membership.reload.voting }
        expect(membership.voting).to be_instance_of Voting
      end

      it "changes membership state to being_polled" do
        expect { subject.perform(params) }.to change { membership.reload.state }.from('new').to('being_polled')
      end

      it { expect(subject.perform(params).success?).to be_true }

      context "membership is disapproved" do
        let(:membership) { create(:disapproved_membership) }

        it { expect(subject.perform(params).success?).to be_true }

        it "creates new voting for membership" do
          expect { subject.perform(params) }.to change { membership.reload.voting }
          expect(membership.voting).to be_instance_of Voting
        end

        it "changes membership state to being_polled" do
          expect { subject.perform(params) }.to change { membership.reload.state }.from('disapproved').to('being_polled')
        end
      end

      [:membership_being_polled, :approved_membership].each do |membership_kind|
        context "membership is not prepared for voting (#{membership_kind.to_s.humanize})" do
          let(:membership) { create(membership_kind) }

          it { expect(subject.perform(params).success?).to be_false }

          it "no voting for membership is created" do
            expect { subject.perform(params) }.to_not change { membership.reload.voting }
          end

          it "membership state does not change" do
            expect { subject.perform(params) }.to_not change { membership.reload.state }
          end
        end
      end
    end
  end
end
