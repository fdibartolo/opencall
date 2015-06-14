require "rails_helper"

RSpec.describe Role, :type => :model do
  describe "#name" do
    let(:role) { FactoryGirl.build(:role) }
    
    it "should be mandatory" do
      role.name = nil
      expect(role.valid?).to be false
      expect(role.errors['name']).to include "can't be blank"
    end

    it "should be unique" do
      FactoryGirl.create(:role)
      expect(role.valid?).to be false
      expect(role.errors['name']).to include "has already been taken"
    end
  end

  describe ".admins_and_reviewers" do
    let!(:admin) { FactoryGirl.create :admin, first_name: 'admin' }
    let!(:reviewer) { FactoryGirl.create :reviewer, first_name: 'reviewer' }

    it "should include admins" do
      expect(Role.admins_and_reviewers).to include admin
    end

    it "should include reviewers" do
      expect(Role.admins_and_reviewers).to include reviewer
    end

    it "should not duplicate user if he is admin and reviewer" do
      reviewer.roles << admin.roles.first
      expect(Role.admins_and_reviewers.count).to be 2
      expect(Role.admins_and_reviewers).to include admin
      expect(Role.admins_and_reviewers).to include reviewer
    end
  end
end
