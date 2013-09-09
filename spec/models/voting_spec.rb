require 'spec_helper'

describe Voting do
  subject { create(:voting) }

  context 'initialization' do
    subject { Voting.new }

    it { expect(subject.closed).to be_false }
  end

  context "scopes" do
    subject { described_class }
    let(:voter) { create(:user, membership: create(:approved_membership)) }

    describe ".available_to_answer_for" do
      context "active voting for voter exists" do
        let!(:voting_for_voter) do
          create(:voting, :active, membership: create(:membership_being_polled, user: voter))
        end

        context "active voting for other candidate exists" do
          let!(:voting_for_other_candidate) do
            create(:voting, :active, membership: create(:membership_being_polled, user: create(:user)))
          end

          context "active, closed voting for other candidate exists" do
            let!(:closed_voting_for_other_candidate) do
              create(:voting, :active, closed: true, membership: create(:membership_being_polled, user: create(:user)))
            end

            it { expect(subject.available_to_answer_for(voter)).to include voting_for_other_candidate }

            it { expect(subject.available_to_answer_for(voter)).to_not include voting_for_voter }

            it { expect(subject.available_to_answer_for(voter)).to_not include closed_voting_for_other_candidate }

            context "voter is admin" do
              before { voter.add_role(:admin) }

              it { expect(subject.available_to_answer_for(voter)).to include closed_voting_for_other_candidate }
            end

            context "voter has no approved membership" do
              let!(:unapproved_voter) { create(:user, membership: create(:membership)) }

              it { expect(subject.available_to_answer_for(unapproved_voter)).to_not include voting_for_other_candidate }
            end
          end
        end
      end
    end

    describe ".not_voted_by" do
      let(:voter) { create(:user) }

      context "voter already voted for voting" do
        let!(:voting) { create(:voting, votes: [create(:vote, voter: voter)]) }

        it { expect(subject.not_voted_by(voter)).to be_empty }
      end

      context "voter did not vote for voting" do
        let!(:voting) { create(:voting, votes: [create(:vote)]) }

        it { expect(subject.not_voted_by(voter)).to include voting }
      end
    end

    describe ".active" do
      context "3 inactive active votings" do
        before { create_list(:voting, 3, :inactive) }

        it { expect(subject.active).to be_empty }
      end

      context "2 active votings for memberships being polled" do
        let!(:votings_with_polled_memberships) do
          create_list(:voting, 2, :active, :membership_being_polled)
        end

        it { expect(subject.active).to include *votings_with_polled_memberships }

        context "2 active votings for approved memberships" do
          let!(:votings_with_approved_memberships) do
            create_list(:voting, 2, :active, :approved_membership)
          end

          it { expect(subject.active).to include *votings_with_polled_memberships }
          it { expect(subject.active).to_not include *votings_with_approved_memberships }
        end
      end
    end

    describe ".not_for" do
      let!(:candidate) { create(:user) }

      context "voting is for candidate given" do
        before { create(:voting, membership: create(:membership, user: candidate)) }

        it { expect(subject.not_for(candidate)).to be_empty }
      end

      context "voting is not for candidate given" do
        let(:voting) { create(:voting, membership: create(:membership, user: create(:user))) }

        it { expect(subject.not_for(candidate)).to include voting }
      end
    end


    describe ".get_random_for" do
      context "active voting for voter exists" do
        let!(:voting_for_voter) do
          create(:voting, :active, membership: create(:membership_being_polled, user: voter))
        end

        context "active voting for other candidate exists" do
          let!(:voting_for_other_candidate) do
            create(:voting, :active, membership: create(:membership_being_polled, user: create(:user)))
          end

          it { expect(subject.get_random_for(voter)).to eq voting_for_other_candidate }

          it { expect(subject.get_random_for(voter)).to_not eq voting_for_voter }
        end
      end
    end
  end


  describe "#candidate_name" do
    subject { create(:voting, candidate: create(:user, name: 'Tony')) }

    it "returns voting's candidate name" do
      expect(subject.candidate_name).to eq 'Tony'
    end
  end

  describe "#deactivate!" do
    context 'voting is active' do
      subject { create(:voting, active: true) }

      it { expect { subject.deactivate! }.to change { subject.active }.from(true).to(false) }
    end

    context 'voting is not active' do
      subject { create(:voting, active: false) }

      it { expect { subject.deactivate! }.to_not change { subject.active } }
    end
  end

  describe "#passed?" do
    context "no votes" do
      it { expect(subject.passed?).to be_false }
    end

    context "less than 50% of votes for" do
      subject { create(:voting_with_votes, votes_count: {for: 2, against: 3}) }

      it { expect(subject.passed?).to be_false }
    end

    context "50% of votes for" do
      subject { create(:voting_with_votes, votes_count: {for: 2, against: 2}) }

      it { expect(subject.passed?).to be_false }
    end

    context "more than 50% of votes for" do
      subject { create(:voting_with_votes, votes_count: {for: 3, against: 2}) }

      it { expect(subject.passed?).to be_true }
    end
  end

  describe "#voted" do
    context "no votes" do
      it { expect(subject.voted).to eq 0 }
    end

    context "two votes" do
      subject { create(:voting_with_votes, votes_count: 2) }

      it { expect(subject.voted).to eq 2 }
    end
  end

  describe "#voted_for" do
    context "two votes for" do
      subject { create(:voting_with_votes, votes_count: {for: 2}) }

      it { expect(subject.voted_for).to eq 2 }
    end

    context "two votes against" do
      subject { create(:voting_with_votes, votes_count: {against: 2}) }

      it { expect(subject.voted_for).to eq 0 }
    end

    context "one vote for and one on hold" do
      subject { create(:voting_with_votes, votes_count: {for: 1, hold: 1}) }

      it { expect(subject.voted_for).to eq 1 }
    end
  end

  describe "#voted_against" do
    context "two votes for" do
      subject { create(:voting_with_votes, votes_count: {for: 2}) }

      it { expect(subject.voted_against).to eq 0 }
    end

    context "two votes against" do
      subject { create(:voting_with_votes, votes_count: {against: 2}) }

      it { expect(subject.voted_against).to eq 2 }
    end

    context "one vote against and one on hold" do
      subject { create(:voting_with_votes, votes_count: {against: 1, hold: 1}) }

      it { expect(subject.voted_against).to eq 1 }
    end
  end

  describe "#holded_vote" do
    context "two votes for" do
      subject { create(:voting_with_votes, votes_count: {for: 2}) }

      it { expect(subject.holded_vote).to eq 0 }
    end

    context "two votes against" do
      subject { create(:voting_with_votes, votes_count: {against: 2}) }

      it { expect(subject.holded_vote).to eq 0 }
    end

    context "one vote against and three on hold" do
      subject { create(:voting_with_votes, votes_count: {against: 1, hold: 3}) }

      it { expect(subject.holded_vote).to eq 3 }
    end
  end
end
