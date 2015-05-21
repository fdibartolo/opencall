class AddWorkflowStateToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :workflow_state, :string
  end
end
