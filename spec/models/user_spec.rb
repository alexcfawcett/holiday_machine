require "spec_helper"

describe User do

  before do
    @user = User.new forename: "Bob", surname: "Builder", invite_code: "Sage1nvite00", email: "test@bar.com",
                         user_type_id: 1, password: "password", password_confirmation: "password"
  end

  subject { @user }

  context 'on creation' do

  end


  context 'after creation' do
    before do
      subject.save!
    end

    it "gives the correct fullname" do
      subject.full_name.should == @user.forename + " " + @user.surname
    end

    it 'has correct number of holiday years' do
      subject.user_days_for_years.count == 3
    end


    # Broke, problem comparing doubles?
    it 'has the correct base holiday allowance for all years' do
      HolidayYear.all.each do |year|
        puts "Years remaining: #{subject.holidays_left(year)}"
        subject.holidays_left(year).should ==  BigDecimal.new('25.00')
       # expect (subject.holidays_left(year)).to eq BigDecimal.new('25.00')
      end
    end



    describe "Absence associations" do

      let!(:another_user) { create(:user) }

      #let!(:user_holiday) { create(:absence) }
      #let!(:another_user_holiday) { create(:holiday, user: @another_user) }

      let!(:user_absence) {Absence.create(date_from: "20/10/2014", date_to: "24/10/2014",
                                          description: "Test Holiday description",
                                          holiday_status_id: 1, absence_type_id: 1, user_id: subject)}

      its(:absences) { should include(user_absence) }

      #its(:holidays) { should_not include(another_user_holiday) }

      it 'should destroy holiday associations'

    end
  end
end