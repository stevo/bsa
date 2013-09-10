require 'spec_helper'

describe StartVoting do
  let(:controller) { double }
  subject { described_class.new(controller) }

  describe ".perform" do
    context "user with membership" do
      let(:membership) { create(:membership) }
      let!(:user) { create(:user, membership: membership) }
      let(:params) { {user_id: user.id}.with_indifferent_access }
      before { controller.stub(permitted_params: params) }

      it "creates new voting for membership" do
        expect { subject.perform }.to change { membership.reload.voting }
        expect(membership.voting).to be_instance_of Voting
      end

      it "creates open voting" do
        expect(subject.perform.closed).to be_false
      end

      context "voting is to be closed" do
        let(:params) { {user_id: user.id, voting: {closed: true}}.with_indifferent_access }
        it "creates closed voting" do
          expect(subject.perform.closed).to be_true
        end
      end

      it "changes membership state to being_polled" do
        expect { subject.perform }.to change { membership.reload.state }.from('new').to('being_polled')
      end

      it { expect(subject.perform).to be_instance_of Voting }

      context "membership is disapproved" do
        let(:membership) { create(:disapproved_membership) }

        it { expect(subject.perform).to be_instance_of Voting }

        it "creates new voting for membership" do
          expect { subject.perform }.to change { membership.reload.voting }
          expect(membership.voting).to be_instance_of Voting
        end

        it "changes membership state to being_polled" do
          expect { subject.perform }.to change { membership.reload.state }.from('disapproved').to('being_polled')
        end
      end

      [:membership_being_polled, :approved_membership].each do |membership_kind|
        context "membership is not prepared for voting (#{membership_kind.to_s.humanize})" do
          let(:membership) { create(membership_kind) }

          it { expect(subject.perform).to be_false }

          it "no voting for membership is created" do
            expect { subject.perform }.to_not change { membership.reload.voting }
          end

          it "membership state does not change" do
            expect { subject.perform }.to_not change { membership.reload.state }
          end
        end
      end
    end
  end
end
