class AddAudienceCountToSessionProposal < ActiveRecord::Migration[4.2]
  def change
    add_column :session_proposals, :audience_count, :integer
  end
end
