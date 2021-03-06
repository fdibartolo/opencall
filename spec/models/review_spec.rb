require "rails_helper"

RSpec.describe Review, :type => :model do
  let(:review) { FactoryGirl.build(:review) }

  describe "mandatory attributes" do
    %w[body private_body score session_proposal_id user_id].each do |attribute|
      it "should include #{attribute}" do
        review = FactoryGirl.build(:review)
        eval "review.#{attribute} = nil"
        expect(review.valid?).to be false
        expect(review.errors[attribute]).to include "can't be blank"
      end
    end
  end  

  describe "optional attributes" do
    it { expect(Review.attribute_names).to include 'second_reviewer_id' }
  end

  describe "#score" do
    it "should be equals or greater than  -2" do
      review.score = -3
      expect(review.valid?).to be false
      expect(review.errors['score']).to include "must be greater than or equal to -2"
    end
    it "should not be greater than 2" do
      review.score = 11
      expect(review.valid?).to be false
      expect(review.errors['score']).to include "must be less than or equal to 2"
    end
  end

  describe "workflow" do
    before :each do
      review.user = FactoryGirl.create :reviewer
      review.save!
    end
    context "while in initial state" do
      it "should be 'pending'" do
        expect(review.pending?).to be true
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