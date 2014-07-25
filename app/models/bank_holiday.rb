class BankHoliday < ActiveRecord::Base
  validates :name, :date_of_hol, presence: true
  attr_accessible :name, :date_of_hol

  scope :in_between, lambda { |from_date, to_date|  where "date_of_hol between ? and ? ", from_date, to_date}
end
