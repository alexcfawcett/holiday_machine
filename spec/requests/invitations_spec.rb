require 'spec_helper'

describe "Invitation" do
  
  subject { page }
  let(:manager) { FactoryGirl.create(:manager) }
  let(:invitee) { 'invite_user_test@example.com' }
  
  describe "send invitation" do
    
    before do 
      sign_in manager
      visit new_user_invitation_path
    end
    
    it "creates a new user" do
      expect do
        fill_in 'Email', with: invitee
        click_button 'Send invitation'
      end.to change{User.count}.by(1)
    end

    it "correctly stores the user type" do
      fill_in 'Email', with: invitee
      select 'Manager', from: 'User type'
      click_button 'Send invitation'
      expect(User.last.user_type.name).to eql('Manager')
    end

    it "stores the invite sender as the user's manager" do
      fill_in 'Email', with: invitee
      click_button 'Send invitation'
      expect(User.last.manager).to eql(manager)
    end
    
  end
  
  describe "accept invitation" do
    pending 'please add specs for invitation aceptance'
  end
  
end