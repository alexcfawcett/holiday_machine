require 'spec_helper'

describe "Static pages" do

  subject { page }
  let(:user) { create(:user) }

  shared_examples_for "all static pages" do
    it { expect(subject).to have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { expect(subject).to_not have_title('| Home') }
    it { expect(subject).to have_selector('div.alert.alert-alert', text: I18n.t('devise.failure.unauthenticated')) }

    describe 'clicking on Sign up now' do
      before { click_link 'Sign up now!' }

      it_should_behave_like 'all static pages'

      it { expect(subject).to have_content('Sign up') }
    end

    describe 'clicking on the Forgotten password link' do
      before { click_link 'Reset password' }

      it_should_behave_like 'all static pages'

      it { expect(subject).to have_content('Forgot your password?') }
    end

  end
end

