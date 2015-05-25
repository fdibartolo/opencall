class Ability
  include CanCan::Ability

  def initialize(user)
    can [:edit], SessionProposal do |session_proposal|
      session_proposal.user.email == user.email and Time.now <= SubmissionDueDate
    end

    if user.reviewer?
      can [:review], SessionProposal
    end

    if user.admin?
      can [:manage], SessionProposal
      can [:accept, :reject], Review
    end
  end
end
