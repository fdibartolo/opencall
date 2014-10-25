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

  # POST /session_proposals
  # POST /session_proposals.json
  def create
    @session_proposal = SessionProposal.new(session_proposal_params)

    respond_to do |format|
      if @session_proposal.save
        format.html { redirect_to @session_proposal, notice: 'Session proposal was successfully created.' }
        format.json { render :show, status: :created, location: @session_proposal }
      else
        format.html { render :new }
        format.json { render json: @session_proposal.errors, status: :unprocessable_entity }
      end
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

  # DELETE /session_proposals/1
  # DELETE /session_proposals/1.json
  def destroy
    @session_proposal.destroy
    respond_to do |format|
      format.html { redirect_to session_proposals_url, notice: 'Session proposal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session_proposal
      @session_proposal = SessionProposal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def session_proposal_params
      params[:session_proposal]
    end
end
