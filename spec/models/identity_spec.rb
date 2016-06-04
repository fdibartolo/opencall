require "rails_helper"

RSpec.describe Identity, :type => :model do
  describe "mandatory attributes" do
    %w[provider uid].each do |attribute|
      it "should include #{attribute}" do
        identity = FactoryGirl.build(:identity)
        eval "identity.#{attribute} = nil"
        expect(identity.valid?).to be false
        expect(identity.errors[attribute]).to include "can't be blank"
      end
    end
  end  

  describe "after save" do
    let(:identity) { FactoryGirl.create :identity }

    context "while author" do
      let!(:session_proposal) { FactoryGirl.create :session_proposal, user: identity.user }

      it "should index session proposals if image_url is changed" do
        expect(identity).to receive(:index_sessions_of).with(identity.user)
        identity.image_url = 'http://some_other_url'
        identity.save!
      end
      it "should not index session proposals if image_url is not changed" do
        expect(identity).to_not receive(:index_sessions_of)
        identity.save!
      end
    end
    context "while not author" do
      it "should not index session proposals even if image_url is changed" do
        expect(identity).to_not receive(:index_sessions_of)
        identity.image_url = 'http://some_other_url'
        identity.save!
      end
    end
  end

  describe "after destroy" do
    let(:identity) { FactoryGirl.create :identity }

    context "while author" do
      let!(:session_proposal) { FactoryGirl.create :session_proposal, user: identity.user }
  
      it "should index session proposals" do
        expect(identity).to receive(:index_sessions_of).with(identity.user)
        identity.image_url = 'http://some_other_url'
        identity.destroy!
      end
    end
    context "while not author" do
      it "should not index session proposals" do
        expect(identity).to_not receive(:index_sessions_of)
        identity.image_url = 'http://some_other_url'
        identity.destroy!
      end
    end
  end
end
