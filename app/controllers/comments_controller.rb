class CommentsController < ApplicationController
  def create
    @session_proposal = SessionProposal.find(params[:session_proposal_id])
    @session_proposal.comments.create comments_params

    redirect_to @session_proposal
  end

  private
    def comments_params
      params.require(:comment).permit(:author, :body)
    end
end
