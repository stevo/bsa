require 'spec_helper'

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
end
