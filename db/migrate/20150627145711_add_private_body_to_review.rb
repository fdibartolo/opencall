class AddPrivateBodyToReview < ActiveRecord::Migration[4.2]
  def change
    add_column :reviews, :private_body, :text
  end
end
