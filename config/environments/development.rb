HolidayMachine::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => 'gmail.com',
  :user_name            => 'holiday.machine999',
  :password             => 'E1eph4nt',
  :authentication       => 'plain',
  :enable_starttls_auto => true  }

  # ActionMailer::Base.smtp_settings = {
  # :address        => 'smtp.sendgrid.net',
  # :port           => '587',
  # :authentication => :plain,
  # :user_name      => ENV['app4658058@heroku.com'],
  # :password       => ENV['qxlcplcz'],
  # :domain         => 'heroku.com',
  # :enable_starttls_auto => true
  # }

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  config.eager_load = false

end

