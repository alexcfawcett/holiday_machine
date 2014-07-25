Holiday Machine [Rails 4]
------------------

> Create and manage holidays

Requirements
-----------

* ruby 2.0.0p247
* Firefox to test Javascript using the Selenium gem. Check [Selenium changelog] for most recent supported Firefox version (Currently: v29 as of 24/07/14)


Installation
-------------------

```
git clone https://github.com/etskelly/holiday_machine.git
cd holiday_machine
rake db:setup
rake db:setup:populate
bundle exec rails s
```
When installing ensure that in the line:

```
/* /config/environments/development.rb */
config.action_mailer.default_url_options = { :host => 'localhost:3000' }
//The host matches your server's host name
```

Testing
-------------------
You must first setup the test database
```
bundle exec rake db:schema:load RAILS_ENV=test
bundle exec rake db:seed RAILS_ENV=test
```
Then run
```
bundle exec rspec spec/
```

Todo 
-------------
* Managers Interface. Changing absences status', inviting users, reports etc
* Refactor CSS and properly implement bootstrap
* Refactor Rspec tests
* Add help page for accounts (lost password etc)
* Localisation
* Other stuff..


License
----

MIT Copyright 2011 - Eamon Skelly


[Selenium changelog]:http://selenium.googlecode.com/git/rb/CHANGES
