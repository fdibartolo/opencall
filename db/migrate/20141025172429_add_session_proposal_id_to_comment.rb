class AddSessionProposalIdToComment < ActiveRecord::Migration
  def change
    add_column :comments, :session_proposal_id, :integer
  end
end
