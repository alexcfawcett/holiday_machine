require 'spec_helper'

describe "Administration pages" do

  subject { page }
  
  let(:manager){ FactoryGirl.create(:manager) }

  let(:user) { FactoryGirl.create(:user, manager_id: manager.id) }

  let(:absence) {Absence.create!(date_from: "23/07/2014", date_to: "28/07/2014",
                                  description: "Test description", holiday_status_id: 1, absence_type_id: 1,
                                  user_id: user.id)}

  before do
    sign_in manager
    visit administer_index_path
  end
  
  it { expect(subject).to have_title( 'Manage Absences' ) }

  context 'clicking links on the pending request table' do

    describe 'clicking the Approve link' do
      before { click_link 'Approve' }

      it 'should remove the absence from the screen if Approve is selected', js:true do
        expect(subject).to have_content('No pending absence requests found.')

        expect(subject).to have_selector('table tr', count: 0)
      end
    end

    describe 'clicking the Reject link' do
      before { click_link 'Reject' }

      it 'should remove the absence from the screen if Reject is selected', js:true do
        expect(subject).to have_content('No pending absence requests found')

        expect(subject).to have_selector('table tr', count: 0)
      end
    end

    describe 'clicking the Pending link', js:true do
      before { click_link 'Pending' }

      it 'should contain 1 record in the table' do
        expect(subject).to_not have_content('No pending absence requests found')

        # Count is 2 as it takes into account the header row!!
        expect(subject).to have_selector('table tr', count: 2)
      end
    end
  end
  
end