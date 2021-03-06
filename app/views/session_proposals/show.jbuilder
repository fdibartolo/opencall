json.extract! @session_proposal, :id, :title, :summary, :description, :video_link, :audience_count
json.theme @session_proposal.theme.name
json.track @session_proposal.track.name
json.audience @session_proposal.audience.name
json.date @session_proposal.created_at
json.author do
  json.name @session_proposal.user.full_name
  json.avatar_url @session_proposal.user.avatar_url
end
json.tags @session_proposal.tags.select(:name)
json.editable (current_user and can? :edit, @session_proposal)
json.voted (current_user and current_user.session_proposal_voted_ids.include?(@session_proposal.id))
json.faved (current_user and current_user.session_proposal_faved_ids.include?(@session_proposal.id))
json.comment_placeholder comment_placeholder(current_user.id, @session_proposal.user_id) if current_user
