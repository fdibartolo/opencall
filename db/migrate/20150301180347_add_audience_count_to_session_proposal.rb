class AddAudienceCountToSessionProposal < ActiveRecord::Migration
  def change
    add_column :session_proposals, :audience_count, :integer
  end
end
