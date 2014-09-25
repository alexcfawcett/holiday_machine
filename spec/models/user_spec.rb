require "spec_helper"

describe User do

  before do
    @user = User.new forename: "Bob", surname: "Builder", invite_code: "Sage1nvite00", email: "test@bar.com",
                         user_type_id: 1, password: "Passw0rd@", password_confirmation: "Passw0rd@"
    @user.save!
  end

  subject { @user }

  context 'after creation' do
    before do

    end

    it "gives the correct fullname" do
      expect(subject.full_name).to eq(@user.forename + " " + @user.surname)
    end

    it 'has correct number of holiday years' do
      expect(subject.user_days_for_years.count).to eq(3)
    end

    it 'has the correct base holiday allowance for all years' do
      HolidayYear.all.each do |year|
        expect(subject.holidays_left(year)).to eq(BigDecimal.new('25.00'))
      end
    end



    describe "absence associations" do

      let!(:user_absence) {Absence.create(date_from: "20/10/2014", date_to: "24/10/2014",
                                          description: "Test Holiday description",
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
  end
end