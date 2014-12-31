class SessionProposalsController < ApplicationController
  before_action :set_session_proposal, only: [:show, :update]

  def index
    @session_proposals = SessionProposal.all
  end

  def show
  end

  def new
    @session_proposal = SessionProposal.new
  end

  def create
    session_proposal = SessionProposal.new(session_proposal_params)
    if session_proposal.save
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  def update
    if @session_proposal.update(session_proposal_params)
      head :no_content
    else
      head :unprocessable_entity
    end
  end

  private
    def set_session_proposal
      @session_proposal = SessionProposal.find_by(id: params[:id])
      return head(:bad_request, { message: "Unable to find session proposal with id '#{params[:id]}'"}) unless @session_proposal
    end

    def session_proposal_params
      params.require(:session_proposal).permit(:author, :title, :description)
    end
end
