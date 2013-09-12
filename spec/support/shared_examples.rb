shared_context "some user exists" do
  let!(:some_user) { create(:user) }
end

shared_context "some user with approved membership exists" do
  let!(:some_user) { create(:user, :approved_membership) }
end
