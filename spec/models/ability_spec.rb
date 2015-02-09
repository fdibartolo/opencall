require 'rails_helper'
require "cancan/matchers"

RSpec.describe Ability, :type => :model do
  let(:session_proposal) { FactoryGirl.create(:session_proposal) }

  context "when having user role" do
    let(:ability) { Ability.new(session_proposal.user) }

    it { expect(ability).to be_able_to :edit, session_proposal }
    it { expect(ability).to_not be_able_to :edit, SessionProposal.new(user: FactoryGirl.create(:user)) }
    it { expect(ability).to_not be_able_to :review, SessionProposal }
  end

  context "when having reviewer role" do
    let(:user) { FactoryGirl.create(:reviewer) }
    let(:ability) { Ability.new(user) }

    it { expect(ability).to be_able_to :review, SessionProposal }
    it { expect(ability).to_not be_able_to :edit, session_proposal }
  end

  context "when having admin role" do
    let(:user) { FactoryGirl.create(:admin) }
    let(:ability) { Ability.new(user) }

    it { expect(ability).to be_able_to :manage, SessionProposal }
  end
end