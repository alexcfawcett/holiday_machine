require "spec_helper"

describe User do

  subject { User }

  context 'on creation' do

  end


  context 'after creation' do
    before do
      @user = User.create forename: "Bob", surname: "Builder", invite_code: "Sage1nvite00", email: "test@bar.com",
                       user_type_id: 1, password: "password", password_confirmation: "password"
    end

    it "gives the correct fullname" do
      @user.full_name.should == @user.forename + " " + @user.surname
    end

    # Broke, problem comparing doubles?
    it 'has the correct base holiday allowance for all years' do
      HolidayYear.all.each do |year|
        puts "Years remaining: #{@user.get_holiday_allowance_for_selected_year(year)}"

        expect { @user.get_holiday_allowance_for_selected_year(year) }.to eq(25.00)
      end
    end
  end
end