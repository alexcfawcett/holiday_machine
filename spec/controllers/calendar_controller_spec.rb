require 'spec_helper'

describe CalendarController do
  before :each do
    subject.stub :authenticate_user!
    subject.stub(:current_user).and_return(User.new)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index', format: :js
      expect(response).to be_success
    end
  end

end
