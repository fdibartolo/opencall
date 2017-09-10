class AddSecondReviewerIdToReview < ActiveRecord::Migration[4.2]
  def change
    add_column :reviews, :second_reviewer_id, :integer
  end
end
