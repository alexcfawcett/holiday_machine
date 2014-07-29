class UserType < ActiveRecord::Base
  has_one :user
  validates :name, presence: true
  attr_accessible :name
end
