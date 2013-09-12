require 'spec_helper'

describe Contribution do
  context "validations" do
    context "with valid attributes" do
      subject { build(:contribution) }
      it { expect(subject).to be_valid }
    end

    context "with no amount" do
      subject { build(:contribution, amount: nil) }
      it { expect(subject).to_not be_valid }
    end
  end

  describe "#create" do
    context "user with membership exists" do
      let(:approved_membership) { create(:approved_membership) }
      let(:user) { create(:user, membership: approved_membership) }

      it { expect(create(:contribution, user: user).membership_id).to eq approved_membership.id }
    end
  end
end
