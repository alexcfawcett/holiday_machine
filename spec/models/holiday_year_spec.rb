require 'spec_helper'

describe HolidayYear do

  before do
    @user = User.create(forename: "Bob", surname: "Builder")
  end

  it "should have a full name made up of forename and surname" do
    expect(@user.full_name).to eq(@user.forename + " " + @user.surname)
  end

end
