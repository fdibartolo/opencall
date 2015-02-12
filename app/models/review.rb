class Review < ActiveRecord::Base
  belongs_to :session_proposal

  validates :body, :score, :session_proposal_id, :user_id, presence: true
  validates :score, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 10 }
end
