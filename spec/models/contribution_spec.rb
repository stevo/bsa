require 'spec_helper'

describe Contribution do
  describe "validations" do
    context "with valid attributes" do
      subject { build(:contribution)}
      it { expect(subject).to be_valid }
    end

    context "with no amount" do
      subject { build(:contribution, amount: nil)}
      it { expect(subject).to_not be_valid }
    end
  end
end
