class RemoveAuthorFromSessionProposal < ActiveRecord::Migration[4.2]
  def change
    remove_column :session_proposals, :author, :string
  end
end
