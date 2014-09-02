namespace :db do
  desc "Fill database with sample data. Essential data can be found in db/seeds.rb"
  task populate: :environment do
    make_user(false,{
        email: "manager@example.com", 
        user_type_id: 2, 
        manager_id: nil
    })
    5.times do |i| 
      make_user(true,{
        email: "user#{i}@example.com"
      })
    end
  end
end

def make_user(do_absence, options={})
  timestamp = Time.now.strftime('%Y%m%d%H%M%S%L')

  default_options = {
      :forename => Faker::Name.first_name,
      :surname => Faker::Name.last_name,
      :email => "foo-#{timestamp}@example.com",
      :password => "passwordpassword",
      :password_confirmation => "passwordpassword",
      :invite_code => "Sage1nvite00",
      :user_type_id => 1,
      :manager_id => 1
  }
  options.reverse_merge!(default_options)

  user = User.new(options)
  user.skip_confirmation!
  user.save

  make_absence(user) if do_absence
  
end

def make_absence(user, options={})

  default_options = {
      :date_from => (Time.zone.now).strftime('%d/%m/%Y'),
      :date_to => (Time.zone.now + 1.day).strftime('%d/%m/%Y'),
      :absence_type_id => 1,
      :holiday_status_id => 1,
      :description => "Test Holiday"
  }
  options.reverse_merge!(default_options)
  user.absences.create(options)
  
end