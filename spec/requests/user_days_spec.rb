require 'spec_helper'

describe 'Manage Allowances page' do
  subject { page }

  let(:manager) { FactoryGirl.create(:manager) }

  context 'index' do
    describe 'manager access to the page' do
      before do
        sign_in manager
        visit user_days_path
      end

      it { expect(subject).to have_title('Manage Allowances') }
      it { expect(subject).to have_content('Manage Allowances') }

      context 'when a manager has an employee' do
        let!(:employee) { FactoryGirl.create(:user, manager_id: manager.id) }

        before { visit user_days_path }

        it 'has 2 rows in the Manage Allowance grid' do
          expect(subject).to have_selector('div#user_days_holder table tr.user', count: 2)
        end
      end

      context 'when a manager does not have an employee' do
        it 'has 1 row in the Manage Allowance grid' do
          expect(subject).to have_selector('div#user_days_holder table tr.user', count: 1)
        end
      end
    end

    describe 'user access to the page' do

      let(:user) { FactoryGirl.create(:user) }

      before do
        sign_in user
        visit user_days_path
      end

      it { expect(subject).to have_title('Holiday Thyme') }
      it { expect(subject).to have_selector('h3', text: 'My Holidays')}
    end

    describe 'attempting to access the page without authenticating' do
      before { visit user_days_path }

      it { expect(subject).to have_title('Sign In') }
      it { expect(subject).to have_content('Sign In') }
    end
  end
end