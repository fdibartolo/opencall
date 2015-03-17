json.extract! @session_proposal, :id, :title, :track_id, :summary, :description, :video_link, :audience_id, :audience_count
json.tags @session_proposal.tags.select(:id, :name)
