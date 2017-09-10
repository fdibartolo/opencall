class AddSessionProposalFavedIdsToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :session_proposal_faved_ids, :integer, array: true, default: []
  end
end
