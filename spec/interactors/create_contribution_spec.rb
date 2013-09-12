require 'spec_helper'

describe CreateContribution do
  let(:controller) { double }
  subject { described_class.new(controller) }

  describe '.perform' do
    context 'user with approved membership' do
      include_context 'some user with approved membership exists'

      let(:params) { {contribution: {amount: 10}}.with_indifferent_access }
      let(:expiry_setter) { double }
      before { controller.stub(permitted_params: params, parent: some_user) }

      it { expect { subject.perform }.to change { some_user.reload.contributions.count }.by(1) }

      it 'set proper membership_id in contribution' do
        subject.perform
        expect(some_user.reload.contributions.last.membership_id).to eq approved_membership.id
      end

      it 'calls expiry setter' do
        ContributionExpirySetter.should_receive(:new).and_return(expiry_setter)
        expiry_setter.should_receive(:save)
        subject.perform
      end
    end
  end
end
