require 'spec_helper'

describe Admin::EventsController do
  include_context 'logged in as admin'

  describe "POST 'create'" do
    let(:event_name){ 'Super impreza' }
    let(:call_request){ post :create, events: { name: event_name} }

    it { expect{call_request}.to change{Event.count}.by(1)}

    context "after request" do
      before { call_request }

      it { expect(response).to redirect_to(admin_events_path) }
    end
  end
end
