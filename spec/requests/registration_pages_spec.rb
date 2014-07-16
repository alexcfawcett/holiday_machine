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

        it { should have_selector('div.alert.alert-error', text: 'Please review the problems below:') }
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
  end
end
