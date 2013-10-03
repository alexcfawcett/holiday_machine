namespace :db do
  desc "Fill database with sample data. Essential data can be found in db/seeds.rb"
  task populate: :environment do
    make_manager_user
    make_users
  end
end

def make_manager_user
  forname = Faker::Name.first_name
  email = "example-#{11}@example.com"
  surname = Faker::Name.last_name
  password = 'passwordpassword'

  manager_user = User.new(
    forename: forname,
    invite_code: "Sage1nvite00",
    email: email,
    password: password,
    password_confirmation: password,
    surname: surname,
    user_type_id: 2)

    manager_user.skip_confirmation!
    manager_user.save

end

def make_users

  10.times do |n|
    forname = Faker::Name.first_name
    email = "example-#{n+1}@example.com"
    surname = Faker::Name.last_name
    password = 'passwordpassword'

    user = User.new(
      forename: forname,
      invite_code: "Sage1nvite00",
      email: email,
      password: password,
      password_confirmation: password,
      surname: surname,
      manager_id: 11,
      user_type_id: 1)

      user.skip_confirmation!
      user.save
  end
end
