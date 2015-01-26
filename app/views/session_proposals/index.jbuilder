json.total @session_proposals.count
json.sessions @session_proposals do |session_proposal|
  json.extract! session_proposal, :id, :title, :description
  json.author session_proposal.user.full_name
  json.tags session_proposal.tags.map(&:name)
end
