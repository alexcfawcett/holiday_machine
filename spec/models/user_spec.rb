require 'spec_helper'

describe User do

  let(:user) { FactoryGirl.create(:user) }

  subject { user }

  it { expect(subject).to be_valid }

  it { expect(subject.is_manager?).to eq(false)}

  it { expect(subject.user_type.name).to eq('Standard') }

  it { expect(subject.all_staff.size).to eq(0) }

  context '#create' do
    describe 'setting incorrect invite code' do

      let(:invalid_user) { User.create(forename: 'Liam',
                                  surname: 'Lagay',
                                  invite_code: 'Sage1nvite01',
                                  email: 'liam.lagay@gmail.com',
                                  user_type_id: UserTypeConstants::USER_TYPE_STANDARD,
                                  password: 'Passw0rd@',
                                  password_confirmation: 'Passw0rd@') }

      it { expect(invalid_user).to_not be_valid }
    end

    describe 'not providing an invite code' do
      let(:invalid_user) { User.create(forename: 'Liam',
                                       surname: 'Lagay',
                                       invite_code: '',
                                       email: 'liam.lagay@gmail.com',
                                       user_type_id: UserTypeConstants::USER_TYPE_STANDARD,
                                       password: 'Passw0rd@',
                                       password_confirmation: 'Passw0rd@') }

      it { expect(invalid_user).to_not be_valid }
    end
  end

  context 'after creation' do
    it 'gives the correct fullname' do
      expect(subject.full_name).to eq(subject.forename + " " + subject.surname)
    end

    it 'has correct number of holiday years' do
      expect(subject.user_days_for_years.count).to eq(3)
    end

    it 'has the correct base holiday allowance for all years' do
      HolidayYear.all.each do |year|
        expect(subject.holidays_left(year)).to eq(BigDecimal.new('25.00'))
      end
    end

    describe 'setting invalid data in fields' do
      describe 'setting blank forename' do
        before do
          subject.forename = nil
          subject.save
        end

        it { expect(subject).to_not be_valid }
      end

      describe 'setting blank surname' do
        before do
          subject.surname = nil
          subject.save
        end

        it { expect(subject).to_not be_valid }
      end

      describe 'setting blank user type' do
        before do
          subject.user_type_id = nil
          subject.save
        end

        it { expect(subject).to_not be_valid }
      end
    end

    context '#update' do

      describe 'manager associations' do

        describe 'setting valid manager id to user' do
          let(:manager) { FactoryGirl.create(:manager) }

          before do
            subject.manager_id = manager.id
            subject.save
          end

          it { expect(subject).to be_valid }

          it { expect(subject.manager_id).to eq(manager.id) }

          it { expect(User.active_managers.size).to eq(1) }

          it { expect(manager.all_staff.size).to eq(1) }

          it { expect(User.get_team_users(manager.id).size).to eq(2) }
        end

        describe 'setting manager id to be themselves' do
          before do
            subject.manager_id = subject.id
            subject.save
          end

          it { expect(subject).to_not be_valid }
        end
      end

      describe 'authentication token regeneration if nil' do
        before do
          subject.authentication_token = nil
          subject.save
        end

        it { expect(subject.authentication_token).to_not be_nil }
      end
    end
  end

  context '#destroy' do
    describe 'absence associations' do

      let!(:user_absence) {Absence.create(date_from: '20/10/2014', date_to: '24/10/2014',
                                          description: 'Test Holiday description',
                                          holiday_status_id: HolidayStatusConstants::HOLIDAY_STATUS_PENDING,
                                          absence_type_id: AbsenceTypeConstants::ABSENCE_TYPE_HOLIDAY,
                                          user_id: subject.id)}

      its(:absences) { should include(user_absence) }

      it 'should destroy holiday associations' do
        @absences = subject.absences.to_a
        subject.destroy
        expect(@absences).not_to be_empty
        @absences.each do |absence|
          expect(Absence.where(id: absence.id)).to be_empty
        end

      end

    end

    describe 'user day associations' do
      let!(:user_day) { UserDay.create(no_days: 3, user_id: subject.id, holiday_year_id: 1, reason: 'Test reason')}

      its(:user_days) { should include(user_day) }

      it 'should destroy user days associations' do
        @user_days = subject.user_days.to_a
        subject.destroy
        expect(@user_days).to_not be_empty
        @user_days.each do |user_day|
          expect(UserDay.where(id: user_day.id)).to be_empty
        end
      end
    end

    describe 'user day years associations' do
      let!(:users_day_for_year) { UserDaysForYear.create(user_id: subject.id,
                                                         holiday_year_id: 1,
                                                         days_remaining: 24) }

      its(:user_days_for_years) { should include(users_day_for_year) }

      it 'should destroy user day years associations' do
        @user_days_for_years = subject.user_days_for_years.to_a
        subject.destroy
        expect(@user_days_for_years).to_not be_empty
        @user_days_for_years.each do |user_day_for_year|
          expect(UserDaysForYear.where(id: user_day_for_year.id)).to be_empty
        end
      end
    end
  end
end