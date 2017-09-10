class CreateJoinTableSessionProposalTag < ActiveRecord::Migration[4.2]
  def change
    create_join_table :session_proposals, :tags do |t|
      t.index :session_proposal_id
      t.index :tag_id
    end
  end
end
