json.reviews @session_proposal.reviews do |review|
  json.extract! review, :body, :score
  json.status review.workflow_state
  json.reviewer review.user.full_name
end
