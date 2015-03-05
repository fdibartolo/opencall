class CommentMailer < ApplicationMailer
  def comment_created_email comment
    @user = comment.session_proposal.user
    @session_proposal = comment.session_proposal
    @comment = comment
    mail to: @user.email
  end
end
