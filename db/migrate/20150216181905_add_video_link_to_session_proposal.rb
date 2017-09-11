class AddVideoLinkToSessionProposal < ActiveRecord::Migration[4.2]
  def change
    add_column :session_proposals, :video_link, :string
  end
end
