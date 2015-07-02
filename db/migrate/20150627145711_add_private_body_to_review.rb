class AddPrivateBodyToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :private_body, :text
  end
end
