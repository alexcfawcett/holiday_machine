require 'spec_helper'

describe UserDay do
  let(:user) { FactoryGirl.create(:user) }
  let(:valid_user_day) { UserDay.new(user_id: user.id, no_days: 3, reason: 'Need a holiday', holiday_year_id: 1) }

  subject { valid_user_day }

  it { expect(subject).to be_valid }

  context 'when validation fails' do
    describe 'User Id not defined' do
      before { valid_user_day.user_id = nil }

      it { expect(subject).to_not be_valid }
    end

    describe 'Number of days is not defined' do
      before { valid_user_day.no_days = nil }

      it { expect(subject).to_not be_valid }
    end

    describe 'Reason is not defined' do
      before { valid_user_day.reason = '' }

      it { expect(subject).to_not be_valid }
    end

    describe 'Number of days is not a numerical value' do
      before { valid_user_day.no_days = 'L' }

      it { expect(subject).to_not be_valid }
    end
  end
end
