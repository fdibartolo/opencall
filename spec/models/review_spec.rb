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
end