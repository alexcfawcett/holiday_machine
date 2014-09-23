Holiday Machine [Rails 4]
------------------

A web application for managing employee holiday allowance and allocation, built in Ruby on Rails 4.

This branch is in development, the application is not yet stable enough for release.


Requirements
-----------

* ruby 2.0.0p247
* Firefox to test Javascript using the Selenium gem. Check [Selenium changelog] for most recent supported Firefox version (Currently: v29  --v31 appears to work as of 01/09/14)


Installation
-------------------

```
git clone https://github.com/etskelly/holiday_machine.git
cd holiday_machine
git checkout rails4_feature
bundle exec rake db:setup
bundle exec rake db:populate
rails s
```
When installing ensure that in the line:

```
/* /config/environments/development.rb */
config.action_mailer.default_url_options = { :host => 'localhost:3000' }
//The host matches your server's host name
```


Logging In
-------------------

After installing, you can log in using the following manager account:

**Email:** manager@example.com  
**Password:** passwordpassword


Signing Up
-------------------

You can register for an account using the following invitation code:  
**Sage1nvite00**

You will need to provide a real email address, as the system will send a validation email. If you do not receive the email, check your spam filter (emails are confirmed to send fine, as of 01/09/14).


Testing
-------------------
You must first setup the test database
```
bundle exec rake db:schema:load RAILS_ENV=test
bundle exec rake db:seed RAILS_ENV=test
```
Then run
```
bundle exec rspec
```

**Please note:** the specs require the database to be correctly seeded. Some IDE configurations have been shown to wipe the seed data before running the specs. *All specs should pass.* If you have mass-failure, this may be the cause. Rebuild your test database and run the specs by following the steps above.


Todo 
-------------
* Fix "View" links on "Manage Absences" page
* Add help and contact pages (covering lost passwords, etc)
* Test and lock down routes as needed (users should not be able to access manager-only areas)
* Replace the SMTP details in config with environment variables, and the change password
* Replace Gmail SMTP with something else (hourly and daily send limits cause exceptions), OR:
* Configure devise to intelligently handle SMTP send rejection (if possible)
* Replace the secret_token (config/initializers/secret_token.rb) with env var for production
* Revisit the calendar drop down options and clarify
* Revisit the "Reports" table, this page could become very long and unusable
* On registration, calculate number of holiday days remaining based on current date
* On invitation, allow manager to set the number of holiday days remaining
* Revisit “Active Team Holidays” list, is this working correctly for both user types?
* Refactor Rspec tests, manually test and add additional specs and fixes where necessary
* Refactor codebase as needed, multiple unused files and routes exist
* Refactor CSS, clean up the Twitter Bootstrap integration
* Browser-test and improve the general style and appearance as necessary
* Add localisation, as needed


Notes
-------------
* Orphaned holiday records cause multiple parts of the system to fail (do not manually delete users from the database)
* Application-wide timezone config has been set (this will affect legacy database records)


License
----

MIT Copyright 2011 - Eamon Skelly


[Selenium changelog]:http://selenium.googlecode.com/git/rb/CHANGES
