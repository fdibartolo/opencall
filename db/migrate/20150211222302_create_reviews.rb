class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :body
      t.integer :score
      t.references :session_proposal, index: true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :reviews, :session_proposals
    add_foreign_key :reviews, :users
  end
end
