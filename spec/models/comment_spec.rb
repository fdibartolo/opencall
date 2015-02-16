require "rails_helper"

RSpec.describe Comment, :type => :model do
  describe "mandatory attributes" do
    let(:comment) { FactoryGirl.create(:session_proposal_with_comment).comments.first }

    %w[body session_proposal_id user_id].each do |attribute|
      it "should include #{attribute}" do
        eval "comment.#{attribute} = nil"
        expect(comment.valid?).to be false
        expect(comment.errors[attribute]).to include "no puede estar en blanco"
      end
    end
  end  
end