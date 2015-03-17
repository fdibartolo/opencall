class AddThemeIdToSessionProposal < ActiveRecord::Migration
  def change
    add_column :session_proposals, :theme_id, :integer
  end
end
