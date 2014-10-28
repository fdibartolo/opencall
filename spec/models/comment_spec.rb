require "rails_helper"

RSpec.describe Comment, :type => :model do
  describe "attributes" do
    it { expect(Comment.attribute_names).to include 'author' }
    it { expect(Comment.attribute_names).to include 'body' }
  end  
end