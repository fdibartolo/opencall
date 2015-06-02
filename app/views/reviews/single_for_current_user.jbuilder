json.reviewers @reviewers do |reviewer|
  json.extract! reviewer, :id, :full_name
end
if @review
  json.extract! @review, :body, :score
  json.status @review.workflow_state
end
