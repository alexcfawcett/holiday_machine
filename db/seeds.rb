# 2014 Holidays
BankHoliday.create!([{:name=>'New Years Day', :date_of_hol=>'2011-01-01'},
                   {:name=>'Good Friday', :date_of_hol=>'2011-04-18'},
                   {:name=>'Easter Monday', :date_of_hol=>'2011-04-21'},
                   {:name=>'Early May Bank Holiday', :date_of_hol=>'2011-05-05'},
                   {:name=>'Spring Bank Holiday', :date_of_hol=>'2011-05-26'},
                   {:name=>'Summer Bank Holiday', :date_of_hol=>'2014-08-25'},
                   {:name=>'Christmas Day', :date_of_hol=>'2014-12-25'},
                   {:name=>'Boxing Day', :date_of_hol=>'2014-12-26'}])

# 2015 Holidays
BankHoliday.create!([{:name=>'New Years Day', :date_of_hol=>'2015-01-01'},
                   {:name=>'Good Friday', :date_of_hol=>'2015-04-03'},
                   {:name=>'Easter Monday', :date_of_hol=>'2015-04-06'},
                   {:name=>'Early May Bank Holiday', :date_of_hol=>'2015-05-04'},
                   {:name=>'Spring Bank Holiday', :date_of_hol=>'2015-05-25'},
                   {:name=>'Summer Bank Holiday', :date_of_hol=>'2015-08-31'},
                   {:name=>'Christmas Day', :date_of_hol=>'2015-12-25'},
                   {:name=>'Boxing Day (Substitute)', :date_of_hol=>'2015-12-28'}])

# 2016 Holidays
BankHoliday.create!([{:name=>'New Years Day', :date_of_hol=>'2016-01-01'},
                     {:name=>'Good Friday', :date_of_hol=>'2016-03-25'},
                     {:name=>'Easter Monday', :date_of_hol=>'2016-03-28'},
                     {:name=>'Early May Bank Holiday', :date_of_hol=>'2016-05-02'},
                     {:name=>'Spring Bank Holiday', :date_of_hol=>'2016-05-30'},
                     {:name=>'Summer Bank Holiday', :date_of_hol=>'2016-08-29'},
                     {:name=>'Christmas Day (Substitute)', :date_of_hol=>'2016-12-27'},
                     {:name=>'Boxing Day', :date_of_hol=>'2016-12-26'}])

HolidayYear.create!([{:description => "Oct 2013 to Sept 2014", :date_start => "2013-10-01", :date_end=> "2014-09-30"},
                   {:description => "Oct 2014 to Sept 2015", :date_start => "2014-10-01", :date_end=> "2015-09-30"},
                   {:description => "Oct 2015 to Sept 2016", :date_start => "2015-10-01", :date_end=> "2016-09-30"}])

UserType.create!([{:name => "Standard"},
                {:name => "Manager"}])

AbsenceType.create([{:name => 'Holiday'},
                   {:name => 'Illness'},
                   {:name => 'Maternity/Paternity'},
                   {:name => 'Family'},
                   {:name => 'Other'}])

HolidayStatus.create!([{:status => 'Pending'},
                     {:status => 'Authorised'},
                     {:status => 'Cancelled'},
                     {:status => 'Taken'}])
