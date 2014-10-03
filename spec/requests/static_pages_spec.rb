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

    context 'clicking on the Forgotten password link' do
      before { click_link 'Reset password' }

      it_should_behave_like 'all static pages'

      it { expect(subject).to have_content('Forgot your password?') }

      context 'clicking on the Sign in link' do
        before { click_link 'Sign in' }

        it_should_behave_like 'all static pages'

        it { expect(subject).to have_content('Sign In') }
      end

      context 'clicking on the Sign up link' do
        before { click_link 'Sign up' }

        it_should_behave_like 'all static pages'

        it { expect(subject).to have_content('Sign up') }
      end

      context 'clicking on the receiving confirmation instructions link' do
        let(:submit) { 'Resend confirmation instructions' }

        before { click_link "Didn't receive confirmation instructions?" }

        it_should_behave_like 'all static pages'

        it { expect(subject).to have_content('Resend confirmation instructions')}

        describe 'inputting incorrect data into the form' do

          it "doesn't send resend confirmation instructions to a blank email address" do
            set_email_field('', submit)
            expect(subject).to have_selector('div.alert.alert-error')
          end

          it "doesn't send resend confirmation instructions to an invalid email address" do
            set_email_field('liam@test@dodgy@email.com', submit)
            expect(subject).to have_selector('div.alert.alert-error')
          end

          it "doesn't send unlock instructions to an email which isn't in the DB" do
            set_email_field('validtest@email.com', submit)
            expect(subject).to have_selector('div.alert.alert-error')
          end
        end

        describe 'inputting correct data into the form' do
          it 'redirects to the home page and alerts the user that an email is being sent' do
            pending "This is not as easy as it looks. Parking for now so I can look at other parts"
          end
        end
       end

      context 'clicking on the resend unlock instructions link' do
        before { click_link "Didn't receive unlock instructions?" }

        it_should_behave_like 'all static pages'

        it { expect(subject).to have_content('Resend unlock instructions') }

        describe 'inputting incorrect data into the form' do
          let(:submit) { 'Resend unlock instructions' }

          it "doesn't send unlock instructions to a blank email address" do
            set_email_field('', submit)
            expect(subject).to have_selector('div.alert.alert-error')
          end

          it "doesn't send unlock instructions due to an invalid email address" do
            set_email_field('liam@test@dodgy@email.com', submit)
            expect(subject).to have_selector('div.alert.alert-error')
          end

          it "doesn't send unlock instructions to an email which isn't in the DB" do
            set_email_field('validtest@email.com', submit)
            expect(subject).to have_selector('div.alert.alert-error')
          end
        end

        describe 'inputting correct data into the form' do
          pending 'needs input on whether we want to lock accounts. Is easy to set up though.'
        end
      end
    end

  end
end

