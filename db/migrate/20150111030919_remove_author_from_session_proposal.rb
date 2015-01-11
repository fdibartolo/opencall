class RemoveAuthorFromSessionProposal < ActiveRecord::Migration
  def change
    remove_column :session_proposals, :author, :string
  end
end
