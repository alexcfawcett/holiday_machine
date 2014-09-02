require 'spec_helper'

describe "Administration pages" do

  subject { page }
  
  let!(:manager){ FactoryGirl.create(:manager) }
  
  before do
    sign_in manager
    visit administer_index_path
  end
  
  it { should have_title( 'Manage Absences' ) }
  
  context "with no subordinates" do
    
    it { should have_content( 'No absences found.' ) }
    
  end
  
end