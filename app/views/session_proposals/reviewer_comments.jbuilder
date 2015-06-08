json.themes Theme.all.map(&:name)
json.sessions SessionProposal.all do |session_proposal|
  json.extract! session_proposal, :id, :title
  json.theme session_proposal.theme.name
  json.comments session_proposal.reviewer_comments do |comment|
    json.reviewer comment.user.full_name
    json.created_at comment.created_at
  end
end
