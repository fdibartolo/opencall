require "rails_helper"

RSpec.describe SessionProposal, :type => :model do
  describe "attributes" do
    it { expect(SessionProposal.attribute_names).to include 'user_id' }
    it { expect(SessionProposal.attribute_names).to include 'title' }
    it { expect(SessionProposal.attribute_names).to include 'description' }
  end

  describe "#autosave_associated_records_for_tags" do
    let(:session_proposal) { FactoryGirl.build(:session_proposal) }

    it "should create tag if it doesn't exist" do
      session_proposal.tags << FactoryGirl.build(:tag)
      expect { session_proposal.save! }.to change(Tag, :count).by(1)
    end

    it "should not create tag if it exists" do
      tag = FactoryGirl.create(:tag)
      session_proposal.tags << tag
      expect { session_proposal.save! }.to change(Tag, :count).by(0)
    end
  end
end