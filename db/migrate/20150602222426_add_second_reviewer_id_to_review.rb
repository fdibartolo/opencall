class AddSecondReviewerIdToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :second_reviewer_id, :integer
  end
end
