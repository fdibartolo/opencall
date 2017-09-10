class AddWorkflowStateAndNotifiedOnToSessionProposal < ActiveRecord::Migration[4.2]
  def change
    add_column :session_proposals, :workflow_state, :string
    add_column :session_proposals, :notified_on, :datetime
  end
end
