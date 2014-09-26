require 'spec_helper'

describe HolidayStatus do

  before {@status = HolidayStatus.new(status: "Pending")}

  subject { @status }

  it { expect(subject).to be_valid }
end
