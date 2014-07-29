require 'spec_helper'

describe BankHoliday do
  describe :validations do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:date_of_hol) }
  end

  describe :security do
    it { should allow_mass_assignment_of(:name) }
    it { should allow_mass_assignment_of(:date_of_hol) }
  end
end
