json.reviews @session_proposal.reviews do |review|
  json.extract! review, :body, :score
  json.reviewer review.user.full_name
end
