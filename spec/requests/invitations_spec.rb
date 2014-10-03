require 'spec_helper'

describe "Invitation" do
  
  subject { page }
  let(:manager) { FactoryGirl.create(:manager) }
  let(:invitee) { 'invite_user_test@example.com' }
  let(:submit) { 'Send invitation' }
  
  describe "send invitation" do
    
    before do 
      sign_in manager
      visit new_user_invitation_path
    end

    context 'supplying invalid data' do
      describe 'clicking the button without supplying an email address' do
        before { click_button submit }

        it { expect(subject).to have_selector('div.alert.alert-error') }
      end

      describe 'supplying an invalid email address' do
        it 'displays an error on the form' do
          set_email_field('dodgyemail@foobar@.com@*', submit)
          expect(subject).to have_selector('div.alert.alert-error')
        end
      end

      describe 'supplying an already existing email address' do
        it 'displays an error on the form' do
          set_email_field(manager.email, submit)
          expect(subject).to have_selector('div.alert.alert-error')
        end
      end
    end

    context 'supplying valid data' do
      it "creates a new user" do
        expect do
          fill_in 'Email', with: invitee
          click_button submit
        end.to change{User.count}.by(1)
      end

      it "correctly stores the user type" do
        fill_in 'Email', with: invitee
        select 'Manager', from: 'User type'
        click_button submit
        expect(User.last.user_type.name).to eq('Manager')
      end

      it "stores the invite sender as the user's manager" do
        fill_in 'Email', with: invitee
        click_button submit
        expect(User.last.manager).to eq(manager)
      end
    end
  end

  describe 'accepting the invitation' do
    pending 'Had a look at this with no joy so far! Needs further looking at'
  end
end