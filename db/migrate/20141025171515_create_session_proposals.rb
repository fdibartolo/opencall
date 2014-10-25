class CreateSessionProposals < ActiveRecord::Migration
  def change
    create_table :session_proposals do |t|

      t.timestamps
    end
  end
end
