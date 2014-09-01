Holiday Machine [Rails 4]
------------------

A web application for managing employee holiday allowance and allocation, built in Ruby on Rails 4.


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

**Also:** there is an ongoing issue that causes four specs in *spec/models/absence_spec.rb* to fail when ran before 10am (confirmed during BST). This issue needs to be resolved.


Todo 
-------------
* Investigate and resolve the morning issues in: spec/models/absence_spec.rb
* Fix "View" links on "Manage Absences" page
* Fix the year selection on "Manage Allowances" page
* Fix holiday rejection; allowance is not always replenished
* Add help and contact pages (covering lost passwords, etc)
* Test and lock down routes as needed (users should not be able to access manager-only areas)
* Revisit the calendar drop down options and clarify
* Revisit the "Reports" table, this page could become very long and unusable
* Refactor Rspec tests, manually test and add additional specs and fixes where necessary
* Refactor codebase as needed, multiple unused files and routes exist
* Refactor CSS, clean up the Twitter Bootstrap integration
* Browser-test and improve the general style and appearance as necessary
* Add localisation, as needed


License
----

MIT Copyright 2011 - Eamon Skelly


[Selenium changelog]:http://selenium.googlecode.com/git/rb/CHANGES
