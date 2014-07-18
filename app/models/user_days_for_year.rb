class UserDaysForYear < ActiveRecord::Base
  #Holds no of days available per user per holiday year
  belongs_to :user
  belongs_to :holiday_year

  validates :user_id, :holiday_year_id, :days_remaining, presence: true
  attr_accessible :user_id, :holiday_year_id, :days_remaining

end
