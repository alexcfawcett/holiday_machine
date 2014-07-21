require "spec_helper"

describe Absence do

  before do
    @user = User.new forename: "Bob", surname: "Builder", invite_code: "Sage1nvite00", email: "test@bar.com",
                     user_type_id: 1, password: "password", password_confirmation: "password"
    @user.save!
  end


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
        @absence = Absence.create(date_from: "20/10/2014", date_to: "24/10/2014",
                                 description: "Test Holiday description",
                               holiday_status_id: 1, absence_type_id: 1, user_id: @user.id)
        @absence = Absence.new(date_from: "22/10/2014", date_to: "24/10/2014", description: "Test Holiday description",
                               holiday_status_id: 1, absence_type_id: 1, user_id: @user.id)
      end

      it "should not be valid" do
        @absence.should_not be_valid
      end
    end

    context 'if a user provides invalid dates' do
      before do
        @absence = Absence.new(date_from: "", date_to: "24/10/2014", description: "Test Holiday description",
                                  holiday_status_id: 1, absence_type_id: 1, user_id: @user.id)
      end

      it "should not be valid" do
        @absence.should_not be_valid
      end
    end

  end

  context 'after creation' do
    before do
      @absence = Absence.new(date_from: "20/10/2014", date_to: "24/10/2014", description: "Test Holiday description",
                             holiday_status_id: 1, absence_type_id: 1, user_id: @user.id)
      @absence.save!
    end

    subject { @absence }

    it { should be_valid }
  end
end
