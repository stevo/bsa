require 'spec_helper'

describe Vote do
  context "candidate exists" do
    let(:candidate) { create(:candidate) }
    subject { build(:vote, voter: voter, voting: candidate.voting) }

    context "voter can vote" do
      let(:voter) { create(:voter) }

      it { should be_valid }

      context "voter votes for the same candidate more than once" do
        let!(:previous_vote) { create(:vote, voter: voter, voting: candidate.voting) }

        it { should_not be_valid }
      end
    end

    context "voter cannot vote" do
      let(:voter) { create(:user) }
      it { should_not be_valid }
    end
  end
end
