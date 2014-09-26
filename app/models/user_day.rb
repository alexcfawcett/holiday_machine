class UserDay < ActiveRecord::Base

  #Contains info about extra days added or removed by a manager to the days for a user

  belongs_to :user
  belongs_to :holiday_year

  attr_accessible :user_id, :no_days, :reason, :holiday_year_id

  validates :user_id, :no_days, :reason, presence: true
  validates :no_days, numericality: true
end
