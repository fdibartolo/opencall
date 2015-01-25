require "rails_helper"

RSpec.describe Comment, :type => :model do
  describe "attributes" do
    it { expect(Comment.attribute_names).to include 'body' }
    it { expect(Comment.attribute_names).to include 'session_proposal_id' }
    it { expect(Comment.attribute_names).to include 'user_id' }
  end  
end