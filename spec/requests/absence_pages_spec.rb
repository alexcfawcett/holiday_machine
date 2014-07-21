require 'spec_helper'

describe "Absence pages" do

  subject { page }

  let(:user) { create(:user) }
  let(:submit) { "Add Leave" }

  before do
    sign_in user
    visit absences_path
  end

  describe "absence creation" do

    describe "with invalid information" do

      it "should not create an absence" do
        expect { click_button "Add Leave" }.not_to change(Absence, :count)
      end

      describe "error messages" do
        before { click_button "Add Leave" }
        it { should have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do

      before do
        fill_in "Date from",        with: "23/07/2014"
        fill_in "Date to",     with: "23/07/2014"
        page.select('Holiday', from: 'Absence type')
        fill_in "Description", with: "Test Description.."
      end

      it "should create an absence" do
        expect { click_button submit }.to change(Absence, :count).by(1)
      end

      describe "after saving the absence" do
        before { click_button submit }

        it { should have_selector('div.alert.alert-success', text: I18n.t('absence_created')) }
      end
    end
  end


=begin
  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
=end
end