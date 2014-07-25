require 'spec_helper'

describe "Static pages" do

  subject { page }
  let(:user) { create(:user) }

  shared_examples_for "all static pages" do
    it { should have_title(full_title(page_title)) }
    it { should have_link('GitHub') }
    it { should have_link('Help') }
  end

  describe "Home page" do
    before { visit root_path }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
    it { should have_selector('div.alert.alert-alert'), text: I18n.t('devise.failure.unauthenticated')}

    describe "for non-signed-in users" do
      it { should have_link('Sign in',       href: sign_in_path) }
      it { should_not have_link('Calendar',       href: '/calendar') }
    end

    describe "for signed-in user" do
      before do
        sign_in user
      end

      it { should have_link('Calendar',       href: '/calendar') }
      it { should have_link('Settings',       href: edit_user_registration_path) }
      it { should have_link('Sign out',       href: sign_out_path) }

      # TODO: Get these tests working by implementing (or using?) factory for managers
=begin
      describe "managers" do
        before do
          click_link "Sign out"
          user.user_type = 2
          sign_in user
        end

        it { should have_link('Management',           href: '#') }
      end
=end
    end
  end
end

