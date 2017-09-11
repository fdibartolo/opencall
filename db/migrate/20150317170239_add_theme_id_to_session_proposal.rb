class AddThemeIdToSessionProposal < ActiveRecord::Migration[4.2]
  def change
    add_column :session_proposals, :theme_id, :integer
  end
end
