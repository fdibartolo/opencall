class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_session_proposal

  def index
    comments = []
    @session_proposal.comments.map {|c| comments << { body: c.body, author: { name: c.user.full_name, avatar_url: c.user.avatar_url }, date: c.created_at }}
    render json: { comments: comments }
  end

  def create
    comment = Comment.new comments_params.merge!({ user_id: current_user.id, session_proposal_id: @session_proposal.id })

    if comment.save
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private
  def set_session_proposal
    @session_proposal = SessionProposal.find_by(id: params[:session_proposal_id])
    return head(:bad_request, { message: "Unable to find session proposal with id '#{params[:session_proposal_id]}'"}) unless @session_proposal
  end

  def comments_params
    params.require(:comment).permit(:body)
  end
end
