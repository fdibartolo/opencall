require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { FactoryGirl.build(:user) }

  describe "mandatory attributes" do
    %w[first_name last_name country email].each do |attribute|
      it "should include #{attribute}" do
        user = FactoryGirl.build(:user)
        eval "user.#{attribute} = nil"
        expect(user.valid?).to be false
        expect(user.errors[attribute]).to include "no puede estar en blanco"
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
    let(:auth) { OmniAuth::AuthHash.new({ :provider => 'provider', :uid => '123456', :info => { name: 'First Last', email: user.email}})}

    it "should create user if no one exist for given omniauth identity" do
      expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
      expect(User.last.email).to eq auth.info.email
    end

    it "should return user if omniauth identity exists" do
      identity = FactoryGirl.create(:identity, provider: auth.provider, uid: auth.uid)
      expect(User.from_omniauth(auth)).to eq identity.user
    end

    it "should add new identity to existing user" do
      FactoryGirl.create :identity
      expect { User.from_omniauth(auth) }.to change(Identity, :count).by(1)
      expect(User.last.identities.count).to eq 2
    end
  end
end
