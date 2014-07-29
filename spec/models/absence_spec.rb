require "spec_helper"
#require'pry'
#binding.pry

describe Absence do

  let(:manager) {User.create! forename: "Bob", surname: "Manager", invite_code: "Sage1nvite00", email: "test2@bar.com",
                          manager_id: 1, user_type_id: 2, password: "password", password_confirmation: "password"}

  let(:user) {User.create! forename: "Bob", surname: "Builder", invite_code: "Sage1nvite00", email: "test@bar.com",
                       manager_id: 1, user_type_id: 1, password: "password", password_confirmation: "password"}

  context 'on creation' do
    context 'if user does not exist' do
      before do
        @absence = Absence.new(date_from: "20/10/2014", date_to: "24/10/2014", description: "Test Holiday description",
                               holiday_status_id: 1, absence_type_id: 1, user_id: 999)
      end

      it "should not be valid" do
        @absence.should_not be_valid
      end
    end

    context 'if a user already has a holiday booked between dates' do
      before do
        Absence.create(date_from: "20/10/2014", date_to: "24/10/2014",
                                 description: "Test Holiday description",
                               holiday_status_id: 1, absence_type_id: 1, user_id: user.id)
        @absence = Absence.new(date_from: "22/10/2014", date_to: "24/10/2014", description: "Test Holiday description",
                               holiday_status_id: 1, absence_type_id: 1, user_id: user.id)
      end

      it "should not be valid" do
        @absence.should_not be_valid
      end
    end

    context 'if a user provides invalid dates' do
      before do
        @absence = Absence.new(date_from: "", date_to: "24/10/2014", description: "Test Holiday description",
                                  holiday_status_id: 1, absence_type_id: 1, user_id: user.id)
      end

      it "should not be valid" do
        @absence.should_not be_valid
      end
    end

  end

  context 'after creation' do

    let(:today) {DateTime.now.strftime("%d/%m/%Y")}
    let(:next_monday) {Date.commercial(Date.today.year, 1+Date.today.cweek, 1).strftime("%d/%m/%Y")}
    let!(:inactive_absence) {Absence.create!(date_from: next_monday, date_to: next_monday,
                                             description: "Test description", holiday_status_id: 1, absence_type_id: 1,
                                             user_id: user.id)}
    let!(:active_absence) {Absence.create!(date_from: today, date_to: today, description: "Test description",
                                           holiday_status_id: 1, absence_type_id: 1, user_id: user.id)}

    subject { active_absence }

    it { should be_valid }
    its(:description) { should eq("Test description") }
    its(:holiday_status_id) { should eq(1) }
    its(:absence_type_id) { should eq(1) }
    its(:user_id) { should eq(user.id) }

    describe '.active_team_holidays' do
      it 'should have the correct record count' do
        Absence.active_team_holidays(user.manager_id).count.should eq(1.0)
      end

      it 'should include active holidays' do
        Absence.active_team_holidays(user.manager_id).should include(active_absence)
      end

      it 'should not include inactive holidays' do
        Absence.active_team_holidays(user.manager_id).should_not include(inactive_absence)
      end
    end

    describe '.upcoming_team_holidays' do
      it 'should have the correct record count' do
        Absence.upcoming_team_holidays(user.manager_id).count.should eq(1.0)
      end

      it 'should include upcoming holidays' do
        Absence.upcoming_team_holidays(user.manager_id).should include(inactive_absence)
      end

      it 'should not include active holidays' do
        Absence.upcoming_team_holidays(user.manager_id).should_not include(active_absence)
      end
    end
  end
end
