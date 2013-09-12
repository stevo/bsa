require 'spec_helper'

shared_examples 'updates approved_at' do
  let(:membership_being_polled) { create(:membership_being_polled) }

  it { expect { call }.to change { membership_being_polled.reload.approved_at }.from(nil) }

  it "sets approved_at to current time" do
    Timecop.freeze(Date.today) do
      call
      expect(membership_being_polled.reload.approved_at).to eq Date.today
    end
  end
end

describe Membership do
  context 'scopes' do
    describe '.active' do
      context 'no approved memberships' do
        before { create(:membership) }

        it 'returns no records' do
          expect(described_class.active).to be_empty
        end
      end

      context 'one approved membership' do
        let!(:approved_membership) { create(:membership, state: 'approved') }

        it 'returns one records' do
          expect(described_class.active).to include approved_membership
        end
      end
    end
  end

  describe "#approve!" do
    let(:call){ membership_being_polled.approve! }
    include_examples "updates approved_at"
  end

  describe "#force_approve!" do
    let(:call){ membership_being_polled.force_approve! }
    include_examples "updates approved_at"
  end
end
