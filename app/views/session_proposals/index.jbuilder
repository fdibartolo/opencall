json.total @session_proposals.count
json.sessions @session_proposals do |session_proposal|
  json.extract! session_proposal, :id, :title, :video_link
  json.theme session_proposal.theme.name
  json.track session_proposal.track.name
  json.author do
    json.name       session_proposal.user.full_name
    json.avatar_url session_proposal.user.avatar_url
  end
  json.tags session_proposal.tags.map(&:name)
end
