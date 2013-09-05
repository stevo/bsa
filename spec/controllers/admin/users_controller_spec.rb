require 'spec_helper'

shared_context "params contain user id" do
  include_context "some user exists"
  before { controller.params[:id] = some_user.id }
end

describe Admin::UsersController do
  include_context 'logged in as admin'

  context 'exposures' do
    describe '#decorated_collection' do
      context "additional user exists" do
        let!(:some_user) { create(:user) }

        it { expect(subject.decorated_collection).to include admin }
        it { expect(subject.decorated_collection).to include some_user }
        it { expect(subject.decorated_collection).to have(2).items }
      end
    end

    describe '#user' do
      include_context "params contain user id"

      it { expect(subject.user).to eq some_user }
    end

    describe '#decorated_user' do
      include_context "params contain user id"

      it { expect(subject.decorated_user).to be_decorated_with UserDecorator }
      it { expect(subject.decorated_user.object).to eq some_user }
    end
  end

  describe "GET 'index'" do
    it 'should be successful' do
      get :index
      expect(response).to be_success
    end
  end

  describe "GET 'show'" do
    include_context "some user exists"

    it 'should be successful' do
      get :show, id: some_user.id
      expect(response).to be_success
    end

    it 'should find the right user' do
      get :show, id: some_user.id
      expect(subject.user).to eq some_user
    end
  end

  describe "PUT 'update'" do
    context "given user exists" do
      context "updating attributes" do
        include_context "some user exists"
        let(:new_name) { 'some_special_name' }
        before { put :update, id: some_user.id, user: {name: new_name} }

        it { expect(some_user.reload.name).to eq new_name }
        it { expect(response).to redirect_to admin_users_path }
      end
    end
  end

  describe "DELETE 'destroy'" do
    context do
      include_context "some user exists"

      it { expect { delete :destroy, id: some_user.id }.to change { User.count }.by(-1) }

      context 'after request' do
        before { delete :destroy, id: some_user.id }
        it { expect(response).to redirect_to admin_users_path }
      end
    end

    it { expect { delete :destroy, id: admin.id }.to_not change { User.count }.by(-1) }
  end
end
