class HolidayStatus < ActiveRecord::Base
  has_one :absence

  validates :status, presence: true
  attr_accessible :status
end