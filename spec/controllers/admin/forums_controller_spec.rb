require 'spec_helper'

describe Admin::ForumsController do
  describe '#index' do
    let!(:forum) { create(:forum) }
    let(:call_request) { get :index }

    it { expect(controller.forums).to include forum }

    context 'after request' do
      before { call_request }

      it { expect(response).to render_template :index }
    end
  end

  describe '#new' do
    let(:call_request) { get :new }

    it { expect(controller.forum).to be_a_new Forum }
  end

  describe '#edit' do
    let!(:call_request) { get :edit, id: forum.id }
    let!(:forum) { create(:forum) }

    it { expect(controller.forum).to eq forum }

  end

  describe '#create' do
    let(:call_request) { post :create, forum: attributes_for(:forum) }

    it { expect{ call_request }.to change { Forum.count }.by 1 }

    context 'after request' do
      before { call_request }

      it { expect(response).to redirect_to action: :index }
    end
  end

  describe '#update' do
    let!(:forum) { create(:forum) }
    let(:call_request) { put :update, id: forum.id, forum: {name: 'New Name'} }

    it { expect{ call_request }.to change{ forum.reload.name }.to 'New Name' }

    context 'after request' do
      before { call_request }

      it { expect(response).to redirect_to action: :index }
    end
  end
end
