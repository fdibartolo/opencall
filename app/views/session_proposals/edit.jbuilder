json.extract! @session_proposal, :id, :title, :track_id, :description, :video_link
json.tags @session_proposal.tags.map(&:name)
