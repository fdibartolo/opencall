class AddUserIdToSessionProposal < ActiveRecord::Migration[4.2]
  def change
    add_column :session_proposals, :user_id, :integer
  end
end
