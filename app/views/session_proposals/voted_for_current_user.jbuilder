json.sessions @session_proposals do |session_proposal|
  json.extract! session_proposal, :id, :title, :description, :video_link
  json.tags session_proposal.tags.map(&:name)
end
