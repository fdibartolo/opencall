class Review < ActiveRecord::Base
  include Workflow

  belongs_to :session_proposal
  belongs_to :user

  validates :body, :score, :session_proposal_id, :user_id, presence: true
  validates :score, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 10 }

  workflow do
    state :awaiting_confirmation do
      event :accept, :transitions_to => :accepted
      event :reject, :transitions_to => :rejected
    end
    state :accepted
    state :rejected
  end
end
