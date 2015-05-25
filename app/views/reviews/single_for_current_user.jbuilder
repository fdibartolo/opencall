if @review
  json.extract! @review, :body, :score
  json.status @review.workflow_state
end
