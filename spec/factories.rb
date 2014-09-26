FactoryGirl.define do
  
  factory :user do
    
    forename "Eamon"
    surname "Skelly"
    sequence(:email) {|n| "person#{n}@example.com" }
    password 'Passw0rd@'
    password_confirmation 'Passw0rd@'
    user_type_id UserTypeConstants::USER_TYPE_STANDARD
    invite_code "Sage1nvite00"
    confirmed_at Time.now #set confirmed_at so we don't need to send emails etc for test user
    
      factory :manager do
        sequence(:email) {|n| "manager#{n}@example.com" }
        user_type_id UserTypeConstants::USER_TYPE_MANAGER
      end
    
  end

  factory :user_type do
	  name "Manager"
  end

  factory :vacation do
    half_day_from "Full Day"
    half_day_to "Full Day"
    date_from Time.zone.now.strftime("%d/%m/%Y")
    date_to (Time.zone.now + 1.week).strftime("%d/%m/%Y")
    holiday_status_id HolidayStatusConstants::HOLIDAY_STATUS_PENDING
    holiday_year_id 1
    description "1 weeks holiday"
  end

  factory :user_days_for_year do
    days_remaining 25
    holiday_year_id HolidayStatusConstants::HOLIDAY_STATUS_PENDING
    association :user, factory: :user
  end

  factory :holiday_year do
    date_start "2013-10-01"
    date_end "2014-09-30"
    description "test year"
  end

  factory :holiday_status do
    status "Pending"
  end

  # Doesn't create?
  factory :absence do
    date_from "18/10/1989"
    date_to "20/10/1989"
    description "Test Holiday description"
    holiday_status_id HolidayStatusConstants::HOLIDAY_STATUS_PENDING
    user_id UserTypeConstants::USER_TYPE_STANDARD
  end
end
