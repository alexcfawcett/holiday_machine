namespace :db do
  desc "Fill database with sample data. Essential data can be found in db/seeds.rb"
  task populate: :environment do

    manager = {surname: "Manager", email: "manager@bar.com", user_type_id: 2, manager_id: nil}
    user = {surname: "User", email: "user@bar.com"}

    make_user(false, manager)
    make_user(false, user)


    5.times {make_user(true)}
  end
end

def make_user(do_absence, options={})
  timestamp = Time.now.strftime('%Y%m%d%H%M%S%L')

  default_options = {
      :forename => Faker::Name.first_name,
      :surname => Faker::Name.last_name,
      :email => "foo-#{timestamp}@bar.com",
      :password => "passwordpassword",
      :password_confirmation => "passwordpassword",
      :invite_code => "Sage1nvite00",
      :user_type_id => 1,
      :manager_id => 1
  }
  options = options.reverse_merge(default_options)

  user = User.new(options)
  user.skip_confirmation!
  user.save

  make_absence({user_id: user.id})
end

def make_absence(options={})

  default_options = {
      :date_from => (Time.now).strftime('%d/%m/%Y'),
      :date_to => (Time.now + 1.day).strftime('%d/%m/%Y'),
      :user_id => 1,
      :absence_type_id => 1,
      :holiday_status_id => 1,
      :description => "Test Holiday"
  }
  options = options.reverse_merge(default_options)

  user = Absence.new(options)
  user.save
end