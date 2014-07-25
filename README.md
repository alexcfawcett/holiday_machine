Holiday Machine
------------------

> Create and manage holidays

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

Requirements
-----------

* ruby 2.0.0p247
* Firefox to test Javascript using the Selenium gem. Check [Selenium changelog] for most recent supported Firefox version (Currently: v29 as of 24/07/14)


Todo 
-------------
* Managers Interface. Changing absences status', inviting users, reports etc
* Users should be able to sort calendar by team members and all
* Refactor CSS and properly implement bootstrap
* Refactor Rspec tests
* Add help page for accounts (lost password etc)
* Localisation


License
----

MIT Copyright 2011 - Eamon Skelly


[Selenium changelog]:http://selenium.googlecode.com/git/rb/CHANGES
