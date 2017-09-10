class CreateSessionProposals < ActiveRecord::Migration[4.2]
  def change
    create_table :session_proposals do |t|
      t.string :author
      t.string :title
      t.text :description

      t.timestamps null: false
    end
  end
end
