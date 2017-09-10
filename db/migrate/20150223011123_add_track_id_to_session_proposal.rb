class AddTrackIdToSessionProposal < ActiveRecord::Migration[4.2]
  def change
    add_column :session_proposals, :track_id, :integer
  end
end
