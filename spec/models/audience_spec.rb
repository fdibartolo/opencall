require "rails_helper"

RSpec.describe Audience, :type => :model do
  describe "#name" do
    let(:audience) { FactoryGirl.build(:audience) }
    
    it "should be mandatory" do
      audience.name = nil
      expect(audience.valid?).to be false
      expect(audience.errors['name']).to include "can't be blank"
    end

    it "should be unique" do
      audience.name = FactoryGirl.create(:audience).name
      expect(audience.valid?).to be false
      expect(audience.errors['name']).to include "has already been taken"
    end
  end
end
