json.reviewers @reviewers do |reviewer|
  json.extract! reviewer, :id, :full_name
end
if @review
  json.extract! @review, :body, :private_body, :score, :second_reviewer_id
  json.status @review.workflow_state
end
