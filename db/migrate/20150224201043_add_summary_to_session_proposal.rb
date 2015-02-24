class AddSummaryToSessionProposal < ActiveRecord::Migration
  def change
    add_column :session_proposals, :summary, :text
  end
end
