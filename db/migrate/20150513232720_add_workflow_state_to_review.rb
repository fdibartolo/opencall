class AddWorkflowStateToReview < ActiveRecord::Migration[4.2]
  def change
    add_column :reviews, :workflow_state, :string
  end
end
