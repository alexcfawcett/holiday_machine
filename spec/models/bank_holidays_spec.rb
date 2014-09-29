require 'spec_helper'

describe BankHoliday do
  let(:bank_holiday) { BankHoliday.create(name: 'Christmas Day', date_of_hol: '25 Dec 2014') }

  subject { bank_holiday }

  it { expect(subject).to be_valid }

  describe 'pulling back the correct number of bank holidays' do
    before do
      @date_from = DateTime.new(2014, 12, 20)
      @date_to = DateTime.new(2014, 12, 26)
    end
    it { expect(BankHoliday.in_between(@date_from, @date_to).size).to eq(2) }
  end

  describe 'pulling back zero bank holidays correctly' do
    before do
      @date_from = DateTime.new(2014, 12, 23)
      @date_to = DateTime.new(2014, 12, 24)
    end

    it { expect(BankHoliday.in_between(@date_from, @date_to).size).to eq(0) }
  end

  describe 'supplying an invalid Bank Holiday name' do
    before do
      subject.name = nil
      subject.save
    end

    it { expect(subject).to_not be_valid }
  end

  describe 'supplying an invalid date of holiday' do
    before do
      subject.date_of_hol = nil
      subject.save
    end

    it { expect(subject).to_not be_valid }
  end
end
