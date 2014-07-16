require 'spec_helper'

describe HolidayStatus do
  describe :validations do
    it { should validate_presence_of(:status) }
  end

  describe :security do
    it { should allow_mass_assignment_of(:status) }
  end
end
