class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_session_proposal, only: [:index, :single_for_current_user, :create]
  before_action :forbid_if_cannot_create, except: [:accept, :reject]
  before_action :forbid_if_cannot_manage, only: [:accept, :reject]
  before_action :set_review, only: [:accept, :reject]

  def index
  end

  def create
    review = Review.find_or_initialize_by(user_id: current_user.id, session_proposal_id: @session_proposal.id)
    review.assign_attributes review_params

    if review.save
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def for_current_user
    @reviews = current_user.reviews
  end

  def single_for_current_user
    @review = current_user.reviews.find_by(session_proposal_id: @session_proposal.id)
  end

  def accept
    @review.accept!
    head :no_content
  end

  def reject
    @review.reject!
    head :no_content
  end

  private
  def forbid_if_cannot_create
    return head :forbidden if cannot? :review, SessionProposal
  end

  def forbid_if_cannot_manage
    return head :forbidden if cannot?(:accept, Review) or cannot?(:reject, Review)
  end

  def review_params
    params.require(:review).permit(:body, :score)
  end

  def set_review
    @review = Review.find_by(id: params[:id])
    return head(:bad_request, { message: "Unable to find review with id '#{params[:id]}'"}) unless @review
  end
end
