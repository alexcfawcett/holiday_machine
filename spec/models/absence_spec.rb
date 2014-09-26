require "spec_helper"

describe Absence do

  let(:manager) {FactoryGirl.create(:manager)}

  let(:user) {FactoryGirl.create(:user, manager_id: manager.id)}

  context 'on creation' do
    context 'when user does not exist' do
      before do
        @absence = described_class.new(date_from: "20/10/2014",
                               date_to: "24/10/2014",
                               description: "Test Holiday description",
                               holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_PENDING,
                               absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY,
                               user_id: 999)
      end

      it { expect(@absence).to_not be_valid }

    end

    context 'when a user already has a holiday booked between dates' do
      before do
        described_class.create(date_from: "20/10/2014",
                       date_to: "24/10/2014",
                       description: "Test Holiday description",
                       holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_PENDING,
                       absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY,
                       user_id: user.id)
        @absence = described_class.new(date_from: "22/10/2014",
                               date_to: "24/10/2014",
                               description: "Test Holiday description",
                               holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_PENDING,
                               absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY,
                               user_id: user.id)
      end

      it { expect(@absence).to_not be_valid }
    end

    context 'when a user provides invalid dates' do
      before do
        @absence = described_class.new(date_from: "",
                               date_to: "24/10/2014",
                               description: "Test Holiday description",
                               holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_PENDING,
                               absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY,
                               user_id: user.id)
      end

      it { expect(@absence).to_not be_valid }
    end

  end

  describe 'scopes' do

    let(:next_monday) { Date.commercial(Date.today.year, 1+Date.today.cweek, 1).in_time_zone.strftime("%d/%m/%Y") }
    let(:last_monday) { Date.commercial(Date.today.year, 1-Date.today.cweek, 1).in_time_zone.strftime("%d/%m/%Y") }
    subject { @active_absence }

    before(:each) do
      today = Time.zone.now.strftime("%d/%m/%Y")
      @active_absence = user.absences.create(date_from: today,
                                                  date_to: today,
                                                  description: "Test description",
                                                  holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_PENDING,
                                                  absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY)

    end

    it { expect(subject).to be_valid }

    describe '.active_team_holidays' do
      
      it 'has an active team holiday record count of 1' do
        expect(described_class.active_team_holidays(user.manager_id).count).to eq(1.0)
      end

      it 'includes the active absence (the subject)' do
        expect(described_class.active_team_holidays(user.manager_id)).to include(subject)
      end

      it 'does not include any upcoming holidays' do
        subject.date_from = next_monday
        subject.date_to = next_monday
        subject.save!
        expect(described_class.active_team_holidays(user.manager_id)).to_not include(subject)
      end
    end

    describe '.upcoming_team_holidays' do
      context 'when a holiday is set to be in the future' do
        before(:each) do
          subject.date_from = next_monday
          subject.date_to = next_monday
          subject.save!
        end

        it 'has an upcoming holiday count of 1' do
          expect(described_class.upcoming_team_holidays(user.manager_id).count).to eq(1.0)
        end

        it 'includes our upcoming holiday defined' do
          expect(described_class.upcoming_team_holidays(user.manager_id)).to include(subject)
        end
      end

      it 'does not include current holidays' do
        expect(described_class.upcoming_team_holidays(user.manager_id)).to_not include(subject)
      end
    end

    describe '#destroy' do

      context 'when in the past' do

        before(:each) do
          subject.date_from = last_monday
          subject.date_to = last_monday
        end

        it 'is not destroyed when Holiday Status is approved' do
          subject.holiday_status_id = HolidayStatusConstants::HOLIDAY_STATUS_APPROVED
          expect { subject.destroy }.to_not change(described_class, :count)
        end

        it 'is not destroyed when Holiday Status is taken' do
          subject.holiday_status_id = HolidayStatusConstants::HOLIDAY_STATUS_TAKEN
          expect { subject.destroy }.to_not change(described_class, :count)
        end

        it 'is destroyed when Holiday Status is pending' do
          subject.holiday_status_id = HolidayStatusConstants::HOLIDAY_STATUS_PENDING
          expect { subject.destroy }.to change(described_class, :count).by(-1)
        end

        it 'is destroyed when Holiday Status is rejected' do
          subject.holiday_status_id = HolidayStatusConstants::HOLIDAY_STATUS_REJECTED
          expect { subject.destroy }.to change(described_class, :count).by(-1)
        end
      end

      it 'is destroyed when the dates are set in the future' do
        subject.date_from = next_monday
        subject.date_to = next_monday
        subject.save!
        expect { subject.destroy}.to change(described_class, :count).by(-1)
      end
    end
  end
end
