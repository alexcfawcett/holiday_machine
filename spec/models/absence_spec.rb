require "spec_helper"
#require'pry'
#binding.pry

describe Absence do

  let(:manager) {FactoryGirl.create(:manager)}

  let(:user) {FactoryGirl.create(:user, manager_id: manager.id)}

  context 'on creation' do
    context 'if user does not exist' do
      before do
        @absence = Absence.new(date_from: "20/10/2014",
                               date_to: "24/10/2014",
                               description: "Test Holiday description",
                               holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_PENDING,
                               absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY,
                               user_id: 999)
      end

      it "should not be valid" do
        expect(@absence).to_not be_valid
      end
    end

    context 'if a user already has a holiday booked between dates' do
      before do
        Absence.create(date_from: "20/10/2014",
                       date_to: "24/10/2014",
                       description: "Test Holiday description",
                       holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_PENDING,
                       absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY,
                       user_id: user.id)
        @absence = Absence.new(date_from: "22/10/2014",
                               date_to: "24/10/2014",
                               description: "Test Holiday description",
                               holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_PENDING,
                               absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY,
                               user_id: user.id)
      end

      it "should not be valid" do
        expect(@absence).to_not be_valid
      end
    end

    context 'if a user provides invalid dates' do
      before do
        @absence = Absence.new(date_from: "",
                               date_to: "24/10/2014",
                               description: "Test Holiday description",
                               holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_PENDING,
                               absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY,
                               user_id: user.id)
      end

      it "should not be valid" do
        expect(@absence).to_not be_valid
      end
    end

  end

  context 'after creation' do

    let(:today) {Time.zone.now.strftime("%d/%m/%Y")}
    let(:next_monday) {Date.commercial(Date.today.year, 1+Date.today.cweek, 1).in_time_zone.strftime("%d/%m/%Y")}
    let(:last_monday) {Date.commercial(Date.today.year, 1-Date.today.cweek, 1).in_time_zone.strftime("%d/%m/%Y")}
    let!(:inactive_absence) {user.absences.create(date_from: next_monday,
                                                  date_to: next_monday,
                                                  description: "Test description",
                                                  holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_PENDING,
                                                  absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY)}
    let!(:active_absence) {user.absences.create(date_from: today,
                                                date_to: today,
                                                description: "Test description",
                                                holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_PENDING,
                                                absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY)}

    let!(:holiday_in_the_past) {user.absences.create(date_from: last_monday,
                                                     date_to: last_monday,
                                                     description: "Test description",
                                                     holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_APPROVED,
                                                     absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY)}

    let!(:taken_holiday) { user.absences.create(date_from: last_monday,
      date_to: last_monday,
      description: 'Taken absence',
      holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_TAKEN,
      absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY)}

    subject { active_absence }

    it { expect(subject).to be_valid }
    its(:description) { should eq("Test description") }
    its(:holiday_status_id) { should eq(HolidayStatusConstants::HOLIDAY_STATUS_PENDING) }
    its(:absence_type_id) { should eq(AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY) }
    its(:user_id) { should eq(user.id) }

    describe '.active_team_holidays' do
      
      it 'should have the correct record count' do
        expect(Absence.active_team_holidays(user.manager_id).count).to eq(1.0)
      end

      it 'should include active holidays' do
        expect(Absence.active_team_holidays(user.manager_id)).to include(active_absence)
      end

      it 'should not include inactive holidays' do
        expect(Absence.active_team_holidays(user.manager_id)).to_not include(inactive_absence)
      end
    end

    describe '.upcoming_team_holidays' do
      it 'should have the correct record count' do
        expect(Absence.upcoming_team_holidays(user.manager_id).count).to eq(1.0)
      end

      it 'should include upcoming holidays' do
        expect(Absence.upcoming_team_holidays(user.manager_id)).to include(inactive_absence)
      end

      it 'should not include active holidays' do
        expect(Absence.upcoming_team_holidays(user.manager_id)).to_not include(active_absence)
      end
    end

    describe 'should allow an upcoming absence to be destroyed' do
      it 'should change the Absence count in the database' do
        expect { inactive_absence.destroy}.to change(Absence, :count).by(-1)
      end
    end

    describe 'should not allow an approved absence in the past to be destroyed' do
      it 'should not change the Absence count in the database' do
        expect { holiday_in_the_past.destroy }.to_not change(Absence, :count)
      end
    end

    describe 'should not allow a previously taken holiday to be destroyed' do
      it 'should not change the Absence count in the DB' do
        expect { taken_holiday.destroy }.to_not change(Absence, :count)
      end
    end
  end
end
