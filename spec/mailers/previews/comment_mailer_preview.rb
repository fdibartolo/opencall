# Preview all emails at http://localhost:3000/rails/mailers/comment_mailer
class CommentMailerPreview < ActionMailer::Preview
  def create
    CommentMailer.comment_created_email(Comment.first)
  end
end
