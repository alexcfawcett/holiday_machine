require "spec_helper"

describe Absence do

  #let!(:user) {create(:user)}
  #let!(:holiday_status) { create(:holiday_status) }


  context 'on creation' do
    context 'should not be valid if user does not exist' do
      before do
        # Broke in testing. Works in console.?
        @absence = Absence.new(date_from: "20/10/2014", date_to: "24/10/2014", description: "Test Holiday description",
                               holiday_status_id: 1, absence_type_id: 1, user_id: 888)
      end
      it { should_not be_valid }
    end

    context 'should not be valid if dates are in the past' do

    end

    context 'should not be valid if a user already has a holiday booked between dates' do

    end

  end

  context 'after creation' do
    before do
      @absence = Absence.new(date_from: "20/10/2014", date_to: "24/10/2014", description: "Test Holiday description",
                             holiday_status_id: 1, absence_type_id: 1, user_id: 888)
      @absence.save!
    end

    subject { @absence }

    it { should be_valid }
  end
end
