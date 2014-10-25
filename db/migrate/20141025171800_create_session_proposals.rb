class CreateSessionProposals < ActiveRecord::Migration
  def change
    create_table :session_proposals do |t|
      t.string :author
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
