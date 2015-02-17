class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_session_proposal, only: :create
  before_action :forbid_if_no_access

  def create
    review = Review.new review_params.merge!({ user_id: current_user.id, session_proposal_id: @session_proposal.id })

    if review.save
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def for_current_user
    @reviews = current_user.reviews
  end

  private
  def set_session_proposal
    @session_proposal = SessionProposal.find_by(id: params[:session_proposal_id])
    return head(:bad_request, { message: "Unable to find session proposal with id '#{params[:session_proposal_id]}'"}) unless @session_proposal
  end

  def forbid_if_no_access
    return head :forbidden if cannot? :review, SessionProposal
  end

  def review_params
    params.require(:review).permit(:body, :score)
  end
end
