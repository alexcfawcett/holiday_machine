require 'spec_helper'

describe "User pages" do

  subject { page }

  shared_examples_for 'invalid form entry' do
    it { expect(subject).to have_selector('div.alert.alert-error') }
    it { expect(subject).to have_content('The form contains 1 error') }
  end

  describe "signup" do

    before { visit register_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { expect(subject).to have_title('Sign up') }

        it { expect(subject).to have_selector('div.alert.alert-error')}
      end
    end

    describe "with valid information" do
      before do
        fill_in "Email",        with: "user@example.com"
        fill_in "user_password",     with: "Passw0rd@"
        fill_in "user_password_confirmation", with: "Passw0rd@"
        fill_in "Forename",      with: "Foo"
        fill_in "Surname", with: "Bar"
        page.select('Standard', from: 'User type')
        fill_in "Invite code", with: "Sage1nvite00"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "when Manager type is selected" do
        before do
          page.select('Manager', from: 'User type')
          click_button submit
        end
        it "creates a manager account" do
          user_type = User.last.user_type.name
          expect(user_type).to eql('Manager')
        end
      end

      describe "after saving the user" do
        before { click_button submit }

        it { expect(subject).to have_selector('div.alert.alert') }
      end

      describe 'the invite code' do
        before do
          fill_in 'Invite code', with: 'Sage1nvite01'
          click_button submit
        end

        it { expect(subject).to have_selector('div.alert.alert-error') }

        it_behaves_like 'invalid form entry'
      end
    end
  end

  describe "edit" do
    let(:user) { create(:user) }
    let(:new_forename)  { "New Name" }
    let(:new_password) { "newPassw0rd@" }
    let(:submit) { 'Save changes' }

    before do
      sign_in user
      visit edit_user_registration_path
    end

    describe "with valid information" do
      before do
        fill_in "Forename", with: new_forename
        click_button submit
      end

      it { expect(subject).to have_selector('h3', text: "#{new_forename} #{user.surname}") }
      it { expect(subject).to have_selector('div.alert.alert', text: I18n.t('devise.registrations.updated')) }
      it { expect(subject).to have_link('Sign Out', href: sign_out_path) }
      specify { expect(user.reload.forename).to  eq new_forename }
    end

    describe "the password field" do

      context 'entering valid password information' do
        before do
          fill_in "New password", with: new_password
          fill_in "New password confirmation", with: new_password
        end

        describe 'entering a valid current password' do
          before do
            fill_in "Current password", with: user.password
            click_button submit
          end
          it { should have_selector('div.alert.alert', text: I18n.t('devise.registrations.updated')) }
          it 'should save the users new password' do
            expect{user.reload}.to change{user.encrypted_password}
          end
        end

        describe 'without supplying a current password' do
          before {click_button submit }

          it_behaves_like 'invalid form entry'
        end
      end

      context 'entering invalid password information' do
        describe 'supply a password of length less than 8 characters' do
          before { set_user_password_in_edit_page(user.password, 'foobar1') }

          it_behaves_like 'invalid form entry'
        end

        describe 'supply a password without a special character' do
          before  { set_user_password_in_edit_page(user.password, 'Passw0rd1') }

          it_behaves_like 'invalid form entry'
        end

        describe 'supply a password without a digit' do
          before { set_user_password_in_edit_page(user.password, 'Password@') }

          it_behaves_like 'invalid form entry'
        end

        describe 'supply a password without an upper case character' do
          before { set_user_password_in_edit_page(user.password, 'passw0rd@') }

          it_behaves_like 'invalid form entry'
        end

        describe 'supply a password without a lower case character' do
          before { set_user_password_in_edit_page(user.password, 'PASSW0RD@') }

          it_behaves_like 'invalid form entry'
        end
      end
    end
  end
end
