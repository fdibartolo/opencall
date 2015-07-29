class SessionProposalsController < ApplicationController
  before_action :authenticate_user!, except: [:search, :show]
  before_action :forbid_if_no_access, only: [:author, :reviewer_comments, :export]
  before_action :forbid_if_cannot_create, only: :create
  before_action only: [:show, :edit, :update, :author] do
    set_resource SessionProposal, params[:id]
  end

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

  def author
    @user = @session_proposal.user
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

  def reviewer_comments
  end

  def export
    respond_to do |f|
      f.csv { send_data SessionProposal.to_csv }
    end
  end

  private
  def session_proposal_params
    params.require(:session_proposal).permit(:title, :summary, :description, :video_link, :track_id, :audience_id, :theme_id, :audience_count, :tags_attributes => [ :id, :name, :_destroy ])
  end

  def forbid_if_no_access
    return head :forbidden if cannot? :review, SessionProposal
  end

  def forbid_if_cannot_create
    return head :forbidden if cannot? :create, SessionProposal
  end
end
