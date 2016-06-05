require 'rails_helper'

RSpec.describe SessionProposalHelper, :type => :helper do
  describe '#comment_placeholder' do
    it "should return author comment placeholder if current user is the proposal author" do
    	current_user_id = 1
    	author_id = 1
      expect(helper.comment_placeholder(current_user_id, author_id)).to eq t('sessions.placeholders.author_comment')
    end

    it "should return public comment placeholder if current user is not the proposal author" do
    	current_user_id = 1
    	author_id = 2
      expect(helper.comment_placeholder(current_user_id, author_id)).to eq t('sessions.placeholders.public_comment')
    end
  end
end
