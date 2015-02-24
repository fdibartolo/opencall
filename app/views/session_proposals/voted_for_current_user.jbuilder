json.sessions @session_proposals do |session_proposal|
  json.extract! session_proposal, :id, :title, :summary, :video_link
  json.track session_proposal.track.name
  json.tags session_proposal.tags.map(&:name)
end
