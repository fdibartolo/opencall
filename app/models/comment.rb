class Comment < ActiveRecord::Base
  belongs_to :session_proposal
  belongs_to :user

  validates :body, :session_proposal_id, :user_id, presence: true
end
