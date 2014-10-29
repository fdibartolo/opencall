class SessionProposalsController < ApplicationController
  before_action :set_session_proposal, only: [:show, :edit, :update, :destroy]

  # GET /session_proposals
  # GET /session_proposals.json
  def index
    @session_proposals = SessionProposal.all
  end

  # GET /session_proposals/1
  # GET /session_proposals/1.json
  def show
  end

  # GET /session_proposals/new
  def new
    @session_proposal = SessionProposal.new
  end

  # GET /session_proposals/1/edit
  def edit
  end

  def create
    session_proposal = SessionProposal.new(session_proposal_params)
    if session_proposal.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  # PATCH/PUT /session_proposals/1
  # PATCH/PUT /session_proposals/1.json
  def update
    respond_to do |format|
      if @session_proposal.update(session_proposal_params)
        format.html { redirect_to @session_proposal, notice: 'Session proposal was successfully updated.' }
        format.json { render :show, status: :ok, location: @session_proposal }
      else
        format.html { render :edit }
        format.json { render json: @session_proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_session_proposal
      @session_proposal = SessionProposal.find(params[:id])
    end

    def session_proposal_params
      params.require(:session_proposal).permit(:author, :title, :description)
    end
end
