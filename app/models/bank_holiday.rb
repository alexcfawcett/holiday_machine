class BankHoliday < ActiveRecord::Base
  validates :name, :date_of_hol, presence: true
  attr_accessible :name, :date_of_hol
end
