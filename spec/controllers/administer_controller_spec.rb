require 'spec_helper'

describe AdministerController do
  let(:manager) { FactoryGirl.create(:manager) }
  let(:user) { FactoryGirl.create(:user, manager_id: manager.id) }

  describe 'attempt to do GET request with manager' do
    before { sign_in manager }

    it 'performs the GET request successfully' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'attempt to do GET request with normal user' do
    before { sign_in user }

    it 'performs the GET request unsuccessfully' do
      get :index
      expect(response).to be_redirect
      expect(response).to redirect_to root_url
    end
  end
end
