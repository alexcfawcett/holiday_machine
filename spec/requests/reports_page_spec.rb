require 'spec_helper'

describe 'Report Pages' do

  subject { page }

  describe 'index' do
    let(:manager) { FactoryGirl.create(:manager) }

    before do
      sign_in manager
      visit reports_path
    end

    it { expect(subject).to have_title('Reports') }
    it { expect(subject).to have_selector('h1', text: 'Reports')}


    describe 'pagination' do
      before(:all) { 31.times { FactoryGirl.create(:user, manager_id: manager.id) } }
      after(:all) { User.delete_all }

      it { expect(subject).to have_selector('div.pagination') }
    end
  end

  describe 'attempting to access the Reports page from a non-manager perspective' do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit reports_path
    end

    it { expect(subject).to have_title('Holiday Thyme') }
    it { expect(subject).to have_content('My Holidays') }
  end

  describe 'attempting to access the Reports page without signing in' do
    before { visit reports_path }

    it { expect(subject).to have_title('Sign In') }
    it { expect(subject).to have_content('Sign In') }
  end
end


