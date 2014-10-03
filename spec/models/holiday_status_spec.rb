require 'spec_helper'

describe HolidayStatus do

  before {@status = HolidayStatus.new(status: "Pending")}

  subject { @status }

  it { expect(subject).to be_valid }

  describe 'providing an invalid status' do
    before do
      subject.status = nil
      subject.save
    end

    it { expect(subject).to_not be_valid }
  end
end
