require "rails_helper"

RSpec.describe TwitterFacade do
  let(:facade) { TwitterFacade.instance }
  let(:session) { FactoryGirl.create :session_proposal}

  describe "#message" do
    before :each do
      facade.session_proposal_id = session.id
    end

    it "should not be nil" do
      facade.message = nil
      expect(facade.valid?).to be false
      expect(facade.errors['message']).to include "can't be blank"
    end

    it "should not be empty" do
      facade.message = ''
      expect(facade.valid?).to be false
      expect(facade.errors['message']).to include "can't be blank"
    end

    it "should not be larger than 140 characters" do
      facade.message = 'x' * 141
      expect(facade.valid?).to be false
      expect(facade.errors['message']).to include "is too long (maximum is 140 characters)"
    end

    it "should be less or equal to 140 characters" do
      facade.message = 'x' * 140
      expect(facade.valid?).to be true
    end
  end

  describe "#session_proposal_id" do
    before :each do
      facade.message = "my tweet"
    end

    it "should be valid if less than 5 mins has elapsed since its creation date" do
      travel_to (session.created_at + 3.minutes) do
        facade.session_proposal_id = session.id
        expect(facade.valid?).to be true
      end
    end

    it "should be invalid if more than 5 mins has elapsed since its creation date" do
      travel_to (session.created_at + 6.minutes) do
        facade.session_proposal_id = session.id
        expect(facade.valid?).to be false
        expect(facade.errors['session_proposal_id']).to include "has expired (>5 mins from its creation date)"
      end
    end
  end

  describe ".update" do
    before :each do
      allow(TwitterClient).to receive(:update).and_return(Twitter::Tweet.new(id: 1))
      facade.session_proposal_id = session.id
    end

    it "should return false while invalid" do
      facade.message = ''
      expect(facade.update).to be false
    end

    it "should return a tweet while valid" do
      facade.message = 'my tweet'
      expect(facade.update).to be_a Twitter::Tweet
    end
  end
end