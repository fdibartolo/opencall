require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { FactoryGirl.build(:user) }

  describe "mandatory attributes" do
    %w[first_name last_name country email].each do |attribute|
      it "should include #{attribute}" do
        user = FactoryGirl.build(:user)
        eval "user.#{attribute} = nil"
        expect(user.valid?).to be false
        expect(user.errors[attribute]).to include "can't be blank"
      end
    end
  end  

  describe "optional attributes" do
    it { expect(User.attribute_names).to include 'phone' }
    it { expect(User.attribute_names).to include 'state' }
    it { expect(User.attribute_names).to include 'city' }
    it { expect(User.attribute_names).to include 'organization' }
    it { expect(User.attribute_names).to include 'website' }
    it { expect(User.attribute_names).to include 'bio' }
  end

  describe "#full_name" do
    it { expect(user.full_name).to eq 'Robert Martin' }
  end

  describe ".from_omniauth" do
    let(:auth) { OmniAuth::AuthHash.new({ :provider => 'provider', :uid => '123456', :info => { name: 'First Last', email: user.email, urls: { public_profile: 'http://my_public_profile' }}})}

    it "should return user if omniauth identity exists" do
      identity = FactoryGirl.create(:identity, provider: auth.provider, uid: auth.uid)
      expect(User.from_omniauth(auth)).to eq identity.user
    end

    it "should add new identity to existing user" do
      FactoryGirl.create :identity
      expect { User.from_omniauth(auth) }.to change(Identity, :count).by(1)
      expect(User.last.identities.count).to eq 2
    end

    context "when user does not exist" do
      it "should create user for given omniauth identity" do
        expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
        expect(User.last.email).to eq auth.info.email
      end

      it "should add linkedin link when provider is linkedin" do
        auth.provider = 'linkedin'

        expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
        expect(User.last.linkedin).to eq auth.info.urls.public_profile
      end

      it "should not add linkedin link when provider is not linkedin" do
        auth.provider = 'github'

        expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
        expect(User.last.linkedin).to be nil
      end
    end
  end

  describe "#avatar_url" do
    let(:identity) { FactoryGirl.create :identity }

    it "should return identity image_url if present" do
      expect(identity.user.avatar_url).to eq identity.image_url
    end

    it "should return default avatar url if identity image_url is not present" do
      identity.image_url = nil
      expect(user.avatar_url).to eq DefaultAvatarUrl
    end

    it "should return default avatar url if user does not have identities" do
      expect(user.avatar_url).to eq DefaultAvatarUrl
    end
  end

  describe "roles" do
    context "with admin role" do
      let(:user) { FactoryGirl.create(:admin) }

      it { expect(user.admin?).to be true }
      it { expect(user.reviewer?).to be false }
    end

    context "with reviewer role" do
      let(:user) { FactoryGirl.create(:reviewer) }

      it { expect(user.reviewer?).to be true }
      it { expect(user.admin?).to be false }
    end
  end

  describe "#add_session_vote" do
    it "should add id to the list" do
      user.add_session_vote 5
      expect(user.session_proposal_voted_ids).to include 5
    end
    it "should not add id again if exists" do
      user.add_session_vote 5
      user.add_session_vote 5
      expect(user.session_proposal_voted_ids).to contain_exactly 5
    end
    it "should not add it if max votes limit is reached" do
      (1..MaxSessionProposalVotes).each { |i| user.session_proposal_voted_ids << i }
      user.add_session_vote 999
      expect(user.session_proposal_voted_ids.count).to eq MaxSessionProposalVotes
    end
    it "should not add it if not a number" do
      user.add_session_vote "3"
      expect(user.session_proposal_voted_ids).to_not include "3"
    end
  end

  describe "#remove_session_vote" do
    it "should remove id from the list" do
      user.session_proposal_voted_ids = [5]
      user.remove_session_vote 5
      expect(user.session_proposal_voted_ids).to_not include 5
    end
  end

  describe "#toggle_session_faved" do
    it "should add id to the list" do
      user.toggle_session_faved 5
      expect(user.session_proposal_faved_ids).to include 5
    end
    it "should remove id from the list" do
      user.session_proposal_faved_ids = [5]
      user.toggle_session_faved 5
      expect(user.session_proposal_faved_ids).to_not include 5
    end
    it "should not add non-numeric id" do
      user.toggle_session_faved "5"
      expect(user.session_proposal_faved_ids).to_not include "5"
    end
  end

  describe "#missing_bio?" do
    %w[bio linkedin aboutme twitter facebook].each do |attribute|
      it "should be false when at least #{attribute} is filled out" do
        user = FactoryGirl.build(:user)
        eval "user.#{attribute} = 'something'"
        expect(user.missing_bio?).to be false
      end
    end

    it "should be true when bio-specific attributes are all emtpty" do
      user = FactoryGirl.build(:user)
      expect(user.missing_bio?).to be true
    end
  end

  describe "#has_session_proposals?" do
    let(:author) { (FactoryGirl.create :session_proposal).user }
    
    it { expect(user.has_session_proposals?).to be false }
    it { expect(author.has_session_proposals?).to be true }
  end
end
