class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action only: [:index, :single_for_current_user, :create] do
    set_resource SessionProposal, params[:session_proposal_id]
  end
  before_action :forbid_if_cannot_create, except: [:accept, :reject]
  before_action :forbid_if_cannot_manage, only: [:accept, :reject]
  before_action only: [:accept, :reject] do
    set_resource Review, params[:id]
  end

  def index
  end

  def create
    review = Review.find_or_initialize_by(user_id: current_user.id, session_proposal_id: @session_proposal.id)
    review.assign_attributes review_params
    exists = review.id?

    if review.save
      ReviewMailer.review_created_email(review).deliver_now unless exists
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def for_current_user
    @reviews = current_user.reviews
  end

  def single_for_current_user
    @reviewers = (Role.find_by(name: RoleAdmin).users + Role.find_by(name: RoleReviewer).users).uniq
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
    params.require(:review).permit(:body, :score, :second_reviewer_id)
  end
end
