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

  describe ".full_name" do
    it { expect(user.full_name).to eq 'Robert Martin' }
  end
end
