require 'spec_helper'

describe ContributionExpirySetter do
  let(:contribution) { create(:contribution, membership: membership, amount: 10) }
  subject { described_class.new(contribution) }

  before { Timecop.freeze(Time.now) }
  after { Timecop.return }

  describe '#save' do

    context 'daily contribution amount is 5' do
      before { Membership.any_instance.stub(daily_contribution_amount: 5) }

      context 'membership has no other contributions' do
        let!(:membership) { create(:approved_membership) }
        it { expect { subject.save }.to change { contribution.reload.expires_at }.to(membership.approved_at + 2.days) }
      end

      context 'membership has contribution with expiry date set' do
        let(:contribution_expiry_date){ Date.today + 2.days }
        let(:membership) { create(:approved_membership) }
        let!(:old_contribution) do
          create(:contribution, membership: membership, expires_at: contribution_expiry_date )
        end

        it {
        expect { subject.save }.to change { contribution.reload.expires_at }.to(contribution_expiry_date + 2.days) }
      end
    end

  end
end
