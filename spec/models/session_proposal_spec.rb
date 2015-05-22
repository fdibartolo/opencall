require "rails_helper"

RSpec.describe SessionProposal, :type => :model do
  let(:session_proposal) { FactoryGirl.build(:session_proposal) }

  describe "mandatory attributes" do
    %w[title summary description user_id track_id audience_id video_link].each do |attribute|
      it "should include #{attribute}" do
        eval "session_proposal.#{attribute} = nil"
        expect(session_proposal.valid?).to be false
        expect(session_proposal.errors[attribute]).to include "can't be blank"
      end
    end
  end  

  describe "optional attributes" do
    it { expect(SessionProposal.attribute_names).to include 'audience_count' }
  end

  describe "#autosave_associated_records_for_tags" do
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

  describe "#as_indexed_json" do
    before :each do
      session_proposal.track = FactoryGirl.create :track
      session_proposal.theme = FactoryGirl.create :theme
      session_proposal.save!
    end
    it { expect(session_proposal.as_indexed_json['title']).to eq session_proposal.title }
    it { expect(session_proposal.as_indexed_json['track']).to eq session_proposal.track.name }
    it { expect(session_proposal.as_indexed_json['theme']).to eq session_proposal.theme.name }
    it { expect(session_proposal.as_indexed_json['author']).to eq session_proposal.user.full_name }
    it "should include tags name" do
      session_proposal.tags << FactoryGirl.create(:tag) << FactoryGirl.create(:tag, name: 'scrum')
      expect(session_proposal.as_indexed_json['tags']).to eq %w[xp scrum]
    end
  end

  describe ".custom_search", :elasticsearch do
    let(:user) { FactoryGirl.create :user }
    let(:track) { FactoryGirl.create :track }
    let(:theme) { FactoryGirl.create :theme }
    let(:first_session_proposal) { FactoryGirl.create :session_proposal, title: 'Advanced TDD', user: user, track: track, theme: theme }
    let(:second_session_proposal) { FactoryGirl.create :session_proposal, title: 'XP', user: user, track: track, theme: theme }
    let(:third_session_proposal) { FactoryGirl.create :session_proposal, title: 'Scaling Scrum', user: user, track: track, theme: theme }

    before :each do
      first_session_proposal.__elasticsearch__.index_document
      second_session_proposal.__elasticsearch__.index_document
      third_session_proposal.__elasticsearch__.index_document
      SessionProposal.__elasticsearch__.refresh_index!
    end

    context "with no criteria" do
      it "should return all documents" do
        expect(SessionProposal.custom_search.results.total).to eq 3
      end
    end

    context "with criteria" do
      it "should return given matching document" do
        expect(SessionProposal.custom_search('tdd').results.total).to eq 1
      end
    end
  end

  describe "workflow" do
    before :each do
      session_proposal.track = FactoryGirl.create :track
      session_proposal.theme = FactoryGirl.create :theme
      session_proposal.save!
    end

    context "while in initial state" do
      it "should be 'new'" do
        expect(session_proposal.new?).to be true
      end
      it "can transition to accepted" do
        expect(session_proposal.can_accept?).to be true
      end
      it "can transition to declined" do
        expect(session_proposal.can_decline?).to be true
      end
    end

    context "while accepting" do
      it "should set notified_on" do
        session_proposal.accept!
        expect(session_proposal.notified_on).to be_within(2.seconds).of DateTime.now
      end
    end
    
    context "while declining" do
      it "should set notified_on" do
        session_proposal.decline!
        expect(session_proposal.notified_on).to be_within(2.seconds).of DateTime.now
      end
    end
    
    context "while accepted" do
      it "cannot transition to declined" do
        session_proposal.accept!
        expect(session_proposal.can_decline?).to be false
      end
    end
  end
end