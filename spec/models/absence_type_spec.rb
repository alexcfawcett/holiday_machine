require 'spec_helper'

describe AbsenceType do
  describe :validations do
    it { should validate_presence_of(:name) }
  end

  describe :security do
    it { should allow_mass_assignment_of(:name) }
  end
end
