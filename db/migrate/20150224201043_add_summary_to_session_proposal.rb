class AddSummaryToSessionProposal < ActiveRecord::Migration[4.2]
  def change
    add_column :session_proposals, :summary, :text
  end
end
