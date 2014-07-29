require 'spec_helper'

describe HolidayStatus do

  before {@status = HolidayStatus.new(status: "Pending")}

  subject { @status }

  it { should be_valid }

  context 'after creation' do
    before do
      subject.save!
    end
  end
end
