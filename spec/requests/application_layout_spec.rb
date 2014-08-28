require 'spec_helper'

describe "Application Layout" do

  before {visit root_url}
  let(:user){FactoryGirl.create(:user)}
  let(:manager){FactoryGirl.create(:manager)}
  subject {page}

  shared_examples_for "all authentication states" do
    it { should have_link('Holiday Thyme', href: root_path) }
    it { should have_link('GitHub') }
    it { should have_link('Help') }
    it { should have_link('Contact') }
  end
  
  shared_examples_for "authenticated as user" do
    it { should_not have_link('Sign In', href: sign_in_path) }
    it { should have_link('Calendar', href: calendar_index_path) }
    it { should have_link('My Settings', href: edit_user_registration_path) }
    it { should have_link('Sign Out', href: sign_out_path) }
  end

  share_examples_for "NOT authenticated as user" do
    it { should have_link('Sign In', href: sign_in_path) }
    it { should_not have_link('Calendar', href: calendar_index_path) }
    it { should_not have_link('My Settings', href: edit_user_registration_path) }
    it { should_not have_link('Sign Out', href: sign_out_path) }
  end

  shared_examples_for "authenticated as manager" do
    it { should have_link('Invitations', href: new_user_invitation_path) }
    it { should have_link('Absences', href: administer_index_path) }
    it { should have_link('Allowances', href: user_days_path) }
    it { should have_link('Reports', href: reports_path) }
  end
  
  share_examples_for "NOT authenticated as manager" do
    it { should_not have_link('Invitations', href: new_user_invitation_path) }
    it { should_not have_link('Absences', href: administer_index_path) }
    it { should_not have_link('Allowances', href: user_days_path) }
    it { should_not have_link('Reports', href: reports_path) }
  end
  
  context "when NOT signed in" do
    it_behaves_like "all authentication states"
    it_behaves_like "NOT authenticated as user"
    it_behaves_like "NOT authenticated as manager"
  end
  
  context "when signed in as a user" do
    before {sign_in(user)}
    it_behaves_like "all authentication states"
    it_behaves_like "authenticated as user"
    it_behaves_like "NOT authenticated as manager"
  end

  context "when signed in as a manager" do
    before {sign_in(manager)}
    it_behaves_like "all authentication states"
    it_behaves_like "authenticated as user"
    it_behaves_like "authenticated as manager"
  end
  
end