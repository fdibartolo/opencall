class AddSessionProposalIdToComment < ActiveRecord::Migration[4.2]
  def change
    add_column :comments, :session_proposal_id, :integer
  end
end
