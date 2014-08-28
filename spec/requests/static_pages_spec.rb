require 'spec_helper'

describe "Static pages" do

  subject { page }
  let(:user) { create(:user) }

  shared_examples_for "all static pages" do
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
    it { should have_selector('div.alert.alert-alert'), text: I18n.t('devise.failure.unauthenticated')}

  end
end

