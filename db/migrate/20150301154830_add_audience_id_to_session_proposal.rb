class AddAudienceIdToSessionProposal < ActiveRecord::Migration
  def change
    add_column :session_proposals, :audience_id, :integer
  end
end
