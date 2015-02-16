json.extract! @session_proposal, :id, :title, :description, :video_link
json.date @session_proposal.created_at
json.author do
  json.name @session_proposal.user.full_name
  json.avatar_url @session_proposal.user.avatar_url
end
json.tags @session_proposal.tags.map(&:name)
json.editable true if can? :edit, @session_proposal
