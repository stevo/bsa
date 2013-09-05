RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
end

shared_context 'logged in as user' do
  let!(:user) { create(:user) }
  before { sign_in user }
end

shared_context 'logged in as admin' do
  let!(:admin) { create(:admin) }
  before { sign_in admin }
end
