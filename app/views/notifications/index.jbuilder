json.themes Theme.all.map(&:name)
json.sessions @session_proposals do |session_proposal|
  json.extract! session_proposal, :id, :title, :notified_on
  json.status session_proposal.workflow_state
  json.theme session_proposal.theme.name
  json.track session_proposal.track.name
  json.author session_proposal.user.full_name
  json.reviews session_proposal.reviews do |review|
    json.extract! review, :score
    json.reviewer review.user.full_name
    json.status review.workflow_state
  end
end
