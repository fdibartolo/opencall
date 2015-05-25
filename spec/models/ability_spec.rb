require 'rails_helper'
require "cancan/matchers"

RSpec.describe Ability, :type => :model do
  let(:session_proposal) { FactoryGirl.create(:session_proposal) }

  context "when having user role" do
    let(:ability) { Ability.new(session_proposal.user) }

    it { expect(ability).to be_able_to :create, SessionProposal }
    it { expect(ability).to be_able_to :edit, session_proposal }
    it { expect(ability).to_not be_able_to :edit, SessionProposal.new(user: FactoryGirl.create(:user)) }
    it { expect(ability).to_not be_able_to :review, SessionProposal }
    it { expect(ability).to_not be_able_to :accept, Review }
    it { expect(ability).to_not be_able_to :reject, Review }

    it "but submission is past due, should not be able to create session proposal" do
      travel_to SubmissionDueDate + 1.day
      expect(ability).to_not be_able_to :create, SessionProposal
    end

    it "but submission is past due, should not be able to edit session proposal" do
      travel_to SubmissionDueDate + 1.day
      expect(ability).to_not be_able_to :edit, session_proposal
    end
  end

  context "when having reviewer role" do
    let(:user) { FactoryGirl.create(:reviewer) }
    let(:ability) { Ability.new(user) }

    it { expect(ability).to be_able_to :review, SessionProposal }
    it { expect(ability).to_not be_able_to :edit, session_proposal }
    it { expect(ability).to_not be_able_to :accept, Review }
    it { expect(ability).to_not be_able_to :reject, Review }
  end

  context "when having admin role" do
    let(:user) { FactoryGirl.create(:admin) }
    let(:ability) { Ability.new(user) }

    it { expect(ability).to be_able_to :manage, SessionProposal }
    it { expect(ability).to be_able_to :accept, Review }
    it { expect(ability).to be_able_to :reject, Review }
  end
end