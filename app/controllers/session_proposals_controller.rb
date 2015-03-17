class SessionProposalsController < ApplicationController
  before_action :authenticate_user!, except: [:search, :show]
  before_action :set_session_proposal, only: [:show, :edit, :update]

  def index
    @session_proposals = SessionProposal.all
  end

  def search
    response = SessionProposal.custom_search(params[:q], params[:page])
    @results = response.results
    @matched_tags = response.response[:aggregations][:matched_tags][:buckets] if response.response[:aggregations]
  end

  def show
  end

  def edit
    return head :forbidden if cannot? :edit, @session_proposal
  end

  def new
    @session_proposal = SessionProposal.new
  end

  def create
    session_proposal = SessionProposal.new(session_proposal_params)
    session_proposal.user = current_user
    if session_proposal.save
      SessionProposalMailer.session_proposal_created_email(session_proposal).deliver_now
      head :no_content, { id: session_proposal.id }
    else
      head :unprocessable_entity
    end
  end

  def update
    return head :forbidden if cannot? :edit, @session_proposal

    if @session_proposal.update(session_proposal_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def for_current_user
    @session_proposals = current_user.session_proposals
  end

  def voted_for_current_user
    @session_proposals = SessionProposal.where(id: current_user.session_proposal_voted_ids)
  end

  def faved_for_current_user
    @session_proposals = SessionProposal.where(id: current_user.session_proposal_faved_ids)
  end

  private
  def set_session_proposal
    @session_proposal = SessionProposal.find_by(id: params[:id])
    return head(:bad_request, { message: "Unable to find session proposal with id '#{params[:id]}'"}) unless @session_proposal
  end

  def session_proposal_params
    params.require(:session_proposal).permit(:title, :summary, :description, :video_link, :track_id, :audience_id, :audience_count, :tags_attributes => [ :id, :name, :_destroy ])
  end
end
