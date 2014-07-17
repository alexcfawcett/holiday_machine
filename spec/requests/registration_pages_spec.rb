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

        it { should have_title('Sign up') }

        it { should have_selector('div.alert.alert-error',
                                  text: I18n.t('simple_form.error_notification.default_message')) }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Email",        with: "user@example.com"
        fill_in "user_password",     with: "password"
        fill_in "user_password_confirmation", with: "password"
        fill_in "Forename",      with: "Foo"
        fill_in "Surname", with: "Bar"
        page.select('Manager', from: 'User type')
        fill_in "Invite code", with: "Sage1nvite00"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }

        it { should have_selector('div.alert.alert') }
      end
    end

    describe "edit" do
      let(:user) { create(:user) }
      let(:new_forename)  { "New Name" }
      let(:new_password) { "newpassword" }

      before do
        sign_in user
        visit edit_user_registration_path
      end

      describe "with valid information" do
        before do
          fill_in "Forename", with: new_forename
          click_button "Save changes"
        end

        it { should have_selector('h3', text: "Hello #{new_forename}") }
        it { should have_selector('div.alert.alert', text: I18n.t('devise.registrations.updated')) }
        it { should have_link('Sign out', href: sign_out_path) }
        specify { expect(user.reload.forename).to  eq new_forename }
      end

      describe "the password field" do

        before do
          fill_in "New password", with: new_password
          fill_in "New password confirmation", with: new_password
        end

        context "without supplying a current password" do
          before {click_button "Save changes" }
          it { should have_selector('div.alert.alert-error',
                                    text: I18n.t('simple_form.error_notification.default_message')) }
        end

        context "with supplying a current password" do
          before do
            fill_in "Current password", with: user.password
            click_button "Save changes"
          end
          it { should have_selector('div.alert.alert', text: I18n.t('devise.registrations.updated')) }
          # This fails but saving seems to work in dev
          specify { expect(user.reload.password).to  eq new_password }
        end
      end
    end

  end
end
