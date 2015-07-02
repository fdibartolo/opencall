class Ability
  include CanCan::Ability

  def initialize(user)
    can [:create], SessionProposal if Time.now <= SubmissionDueDate
    can [:edit], SessionProposal do |session_proposal|
      session_proposal.user.email == user.email and Time.now <= SubmissionDueDate
    end

    if user.reviewer?
      can [:review, :list], SessionProposal
    end

    if user.admin?
      can [:manage], SessionProposal
      can [:accept, :reject], Review
    end
  end
end
