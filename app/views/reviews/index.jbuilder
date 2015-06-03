json.reviews @session_proposal.reviews do |review|
  json.extract! review, :id, :body, :score
  json.status review.workflow_state
  json.reviewer review.user.full_name
  json.second_reviewer User.find_by(id: review.second_reviewer_id).full_name if User.find_by(id: review.second_reviewer_id)
end
