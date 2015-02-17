json.reviews @reviews do |review|
  json.session_proposal_id review.session_proposal.id
  json.session_proposal_title review.session_proposal.title
  json.session_proposal_author review.session_proposal.user.full_name
  json.extract! review, :body, :score
end
