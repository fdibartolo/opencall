class AddWorkflowStateAndNotifiedOnToSessionProposal < ActiveRecord::Migration
  def change
    add_column :session_proposals, :workflow_state, :string
    add_column :session_proposals, :notified_on, :datetime
  end
end
