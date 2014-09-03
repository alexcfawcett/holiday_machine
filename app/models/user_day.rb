class UserDay < ActiveRecord::Base

  #Contains info about extra days added or removed by a manager to the days for a user

  belongs_to :user
  belongs_to :holiday_year

  attr_accessible :user_id, :no_days, :reason, :holiday_year_id
  
  validates_presence_of :user_id
  validates_presence_of :no_days
  validates_presence_of :reason
  validates_numericality_of :no_days

end
