# Preview all emails at http://localhost:3000/rails/mailers/review_mailer
class ReviewMailerPreview < ActionMailer::Preview
  def review_created_email
    ReviewMailer.review_created_email Review.first
  end
end
