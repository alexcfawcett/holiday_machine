class AbsenceType < ActiveRecord::Base
  has_many :absences
  validates :name, presence: true
  attr_accessible :name
end
