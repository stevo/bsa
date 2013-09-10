require 'spec_helper'

shared_examples 'changes membership state to approved' do
  it 'changes membership state to approved' do
    expect do
      subject.perform
    end.to change { membership.reload.state }.to('approved')
  end
end

shared_examples 'deactivates voting' do
  it "deactivates voting" do
    expect { subject.perform }.to change { voting.reload.active }.from(true).to(false)
  end
end

describe SucceedVoting do
  let(:controller) { double }
  subject { described_class.new(controller) }

  describe ".perform" do
    context "user with membership" do
      let(:membership) { create(:membership_being_polled) }
      let!(:user) { create(:user, membership: membership) }
      let(:params) { {user_id: user.id}.with_indifferent_access }
      before { controller.stub(permitted_params: params) }

      include_examples 'changes membership state to approved'

      context 'passing voting exists' do
        let(:voting) { create(:passing_voting) }
        let(:membership) { create(:membership_being_polled, voting: voting) }

        include_examples 'changes membership state to approved'
        include_examples 'deactivates voting'

        context "voting does not pass" do
          let(:voting) { create(:not_passing_voting) }

          include_examples 'deactivates voting'
          include_examples 'changes membership state to approved'
        end
      end
    end
  end
end
