require 'spec_helper'

describe "User pages" do

  subject { page }

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
        fill_in "user_password",     with: "password"
        fill_in "user_password_confirmation", with: "password"
        fill_in "Forename",      with: "Foo"
        fill_in "Surname", with: "Bar"
        page.select('Standard', from: 'User type')
        fill_in "Invite code", with: "Sage1nvite00"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      context "when Manager type is selected" do
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
    end

    describe "edit" do
      let(:user) { create(:user) }
      let(:new_forename)  { "New Name" }
      let(:new_password) { "newpassword" }
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

        before do
          fill_in "New password", with: new_password
          fill_in "New password confirmation", with: new_password
        end

        context "without supplying a current password" do
          before {click_button submit }
          it { expect(subject).to have_selector('div.alert.alert-error') }
          it { expect(subject).to have_content('The form contains 1 error') }
        end

        context "with supplying a current password" do
          before do
            fill_in "Current password", with: user.password
            click_button submit
          end
          it { should have_selector('div.alert.alert', text: I18n.t('devise.registrations.updated')) }
          it 'should save the users new password' do
            expect{user.reload}.to change{user.encrypted_password}
          end
        end
      end
    end

  end
end
