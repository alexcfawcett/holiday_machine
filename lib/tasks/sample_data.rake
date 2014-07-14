namespace :db do
  desc "Fill database with sample data. Essential data can be found in db/seeds.rb"
  task populate: :environment do

    manager = {surname: "Manager", email: "manager@bar.com", user_type_id: 2}
    user = {surname: "User", email: "user@bar.com"}

    make_user(manager)
    make_user(user)

    10.times {make_user}
  end
end

def make_user(options={})
  timestamp = Time.now.strftime('%Y%m%d%H%M%S%L')

  default_options = {
      :forename => Faker::Name.first_name,
      :surname => Faker::Name.last_name,
      :email => "foo-#{timestamp}@bar.com",
      :password => "passwordpassword",
      :password_confirmation => "passwordpassword",
      :invite_code => "Sage1nvite00",
      :user_type_id => 1
  }
  options = options.reverse_merge(default_options)

  user = User.new(options)
  user.skip_confirmation!
  user.save
end