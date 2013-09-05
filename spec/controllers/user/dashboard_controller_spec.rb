require 'spec_helper'

shared_context "with random voting" do
  let(:random_voting) { create(:voting) }
  before { Voting.should_receive(:get_random_for).with(user).and_return(random_voting) }
end

describe User::DashboardController do
  include_context 'logged in as user'

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

  context 'exposures' do
    describe '#voting' do
      include_context "with random voting"

        it "gets random voting for current user" do
          expect(controller.voting).to eq random_voting
        end
    end

    describe '#decorated_voting' do
      include_context "with random voting"

      it "gets decorated random voting for current user" do
        expect(controller.decorated_voting).to be_an_instance_of VotingDecorator
      end

      it "decorator subject is actual voting" do
        expect(controller.decorated_voting.object).to eq random_voting
      end
    end
  end
end
