class AddTrackIdToSessionProposal < ActiveRecord::Migration
  def change
    add_column :session_proposals, :track_id, :integer
  end
end
