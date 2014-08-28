require 'spec_helper'

describe "Authentication" do

  subject { page }

  # Need to exist for tests to run. Possibly change this?
  before do
    @user_type = create(:user_type) #need a user type to exist
    @holiday_year = create(:holiday_year) #need a holiday year to exist
  end

  describe "signin page" do
    before { visit sign_in_path }

    it { should have_content('Sign In') }
    it { should have_title('Sign In') }
    it { should have_link('Sign up now!',    href: register_path) }
  end

  describe "signin" do

    before { visit sign_in_path }

    let(:signin) { "Sign in" }

    describe "with invalid information" do
      before { click_button signin }

      it { should have_title('Sign In') }
      it { should have_selector('div.alert.alert-alert') }

      describe "after visiting another page" do
        before { visit root_path }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      describe "after signing in" do
        it { should have_link('Account',     href: '#') }
        it { should have_link('Sign Out',    href: sign_out_path) }
        it { should_not have_link('Sign In', href: sign_in_path) }

        describe "followed by signout" do
          before { click_link "Sign Out" }
          it { should have_link('Sign In') }
        end
      end
    end
  end
end