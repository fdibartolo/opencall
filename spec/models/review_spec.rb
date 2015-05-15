require "rails_helper"

RSpec.describe Review, :type => :model do
  let(:review) { FactoryGirl.build(:review) }

  describe "mandatory attributes" do
    %w[body score session_proposal_id user_id].each do |attribute|
      it "should include #{attribute}" do
        review = FactoryGirl.build(:review)
        eval "review.#{attribute} = nil"
        expect(review.valid?).to be false
        expect(review.errors[attribute]).to include "can't be blank"
      end
    end
  end  

  describe "#score" do
    it "should be greater than 0" do
      review.score = 0
      expect(review.valid?).to be false
      expect(review.errors['score']).to include "must be greater than 0"
    end
    it "should not be greater than 10" do
      review.score = 11
      expect(review.valid?).to be false
      expect(review.errors['score']).to include "must be less than or equal to 10"
    end
  end

  describe "workflow" do
    before :each do
      review.user = FactoryGirl.create :reviewer
      review.save!
    end
    context "while in initial state" do
      it "should be 'awaiting_confirmation'" do
        expect(review.awaiting_confirmation?).to be true
      end
      it "can transition to accepted" do
        expect(review.can_accept?).to be true
      end
      it "can transition to rejected" do
        expect(review.can_reject?).to be true
      end
    end
    context "while accepted" do
      it "cannot transition to rejected" do
        review.accept!
        expect(review.can_reject?).to be false
      end
    end
  end
end