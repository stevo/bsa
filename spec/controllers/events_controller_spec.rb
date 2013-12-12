require 'spec_helper'

shared_context "some event exists" do
  let!(:some_event) { create(:event) }
end

describe Admin::EventsController do
  include_context 'logged in as admin'

  describe Event do
    let(:event_name) { 'Super impreza' }
    let(:event_starts_at) { Time.now }
    let(:call_request) { post :create, event: {name: event_name,starts_at: event_starts_at} }
    it "should validate presence of" do
      should validate_presence_of event.name
    end
  end


  describe "POST 'create'" do
    let(:event_name) { 'Super impreza' }
    let(:event_starts_at) { Time.now }
    let(:call_request) { post :create, event: {name: event_name,starts_at: event_starts_at} }
    it { expect { call_request }.to change { Event.count }.by(1) }

    context "after request" do
      before { call_request }

      it { expect(response).to redirect_to(admin_events_path) }
    end
  end

  describe "DELETE 'destroy'" do
    context do
      include_context "some event exists"

      it { expect { delete :destroy, id: some_event.id }.to change { Event.count }.by(-1) }

      context 'after request' do
        before { delete :destroy, id: some_event.id }
        it { expect(response).to redirect_to admin_events_path }
      end
    end
  end

  describe "PUT 'update'" do
    context "given event exists" do
      context "publishing" do

        let(:event) { create(:event) }

        it { expect { put :update, id: event.id, event: {transition: 'publish'} }.to change { event.reload.state }.from('new').to('published') }

        it { expect { put :update, id: event.id, event: {transition: 'new'} }.to_not change { event.reload.state } }
      end

      context "updating attributes" do

        let(:old_name) { 'Old name' }
        let(:new_name) { 'New name' }
        let(:old_desc) { 'Old description' }
        let(:new_desc) { 'New description' }
        let(:event) { create(:event, name: old_name, description: old_desc) }
        let(:request_call) { put :update, id: event.id, event: {name: new_name, description: new_desc} }

        it { expect { request_call }.to change { event.reload.name }.from(old_name).to(new_name) }
        it { expect { request_call }.to change { event.reload.description }.from(old_desc).to(new_desc) }

        context 'after request' do
          before { request_call }
          it { expect(response).to redirect_to admin_events_path }
        end
      end
    end
  end

  describe "GET 'index'" do
    it 'should be successful' do
      get :index
      expect(response).to be_success
    end
  end

  describe "GET 'edit'" do
    include_context "some event exists"
    let(:request_call) { get :edit, id: some_event.id }
    before { request_call }

    it { expect(response).to be_success }
  end
end



