class AddUserIdToSessionProposal < ActiveRecord::Migration
  def change
    add_column :session_proposals, :user_id, :integer
  end
end
