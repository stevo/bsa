shared_context "some user exists" do
  let!(:some_user) { create(:user) }
end

shared_context "some user with approved membership exists" do
  let(:approved_membership) { create(:approved_membership) }
  let!(:some_user) { create(:user, membership: approved_membership) }
end
