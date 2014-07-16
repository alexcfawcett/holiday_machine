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
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "password"
        fill_in "Password confirmation", with: "password"
        fill_in "Forename",      with: "Foo"
        fill_in "Surname", with: "Bar"
        #fill_in "user_user_type_id", with: "Manager"

        #save_and_open_page
        page.select('2', from: 'UserType[user_type]')

        fill_in "Invite code", with: "sage001nvite"
        fill_in "Manager", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Sign out') }

        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end
      end
    end
  end
end
