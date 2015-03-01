json.extract! @session_proposal, :id, :title, :track_id, :summary, :description, :video_link, :audience_id
json.tags @session_proposal.tags.map(&:name)
