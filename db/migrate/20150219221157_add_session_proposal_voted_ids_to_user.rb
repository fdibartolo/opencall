class AddSessionProposalVotedIdsToUser < ActiveRecord::Migration
  def change
    add_column :users, :session_proposal_voted_ids, :integer, array: true, default: []
  end
end
