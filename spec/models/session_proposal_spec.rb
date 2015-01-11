require "rails_helper"

RSpec.describe SessionProposal, :type => :model do
  describe "attributes" do
    it { expect(SessionProposal.attribute_names).to include 'user_id' }
    it { expect(SessionProposal.attribute_names).to include 'title' }
    it { expect(SessionProposal.attribute_names).to include 'description' }
  end  
end