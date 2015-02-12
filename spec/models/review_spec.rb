require "rails_helper"

RSpec.describe Review, :type => :model do
  let(:review) { FactoryGirl.build(:review) }

  describe "mandatory attributes" do
    %w[body score session_proposal_id user_id].each do |attribute|
      it "should include #{attribute}" do
        review = FactoryGirl.build(:review)
        eval "review.#{attribute} = nil"
        expect(review.valid?).to be false
        expect(review.errors[attribute]).to include "no puede estar en blanco"
      end
    end
  end  

  describe "#score" do
    it "should be greater than 0" do
      review.score = 0
      expect(review.valid?).to be false
      expect(review.errors['score']).to include "debe ser mayor que 0"
    end
    it "should not be greater than 10" do
      review.score = 11
      expect(review.valid?).to be false
      expect(review.errors['score']).to include "debe ser menor o igual que 10"
    end
  end
end