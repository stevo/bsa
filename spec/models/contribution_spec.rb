require 'spec_helper'

describe Contribution do
  context 'validations' do
    context 'with valid attributes' do
      subject { build(:contribution) }
      it { expect(subject).to be_valid }
    end

    context 'with no amount' do
      subject { build(:contribution, amount: nil) }
      it { expect(subject).to_not be_valid }
    end

    context 'with no membership' do
      subject { build(:contribution, membership: nil) }
      it { expect(subject).to_not be_valid }
    end

    context 'with not approved membership' do
      subject { build(:contribution, membership: create(:new_membership)) }
      it { expect(subject).to_not be_valid }
    end
  end
end
