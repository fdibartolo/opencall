require 'rails_helper'

RSpec.describe Theme, type: :model do
  describe "#name" do
    let(:theme) { FactoryGirl.build(:theme) }
    
    it "should be mandatory" do
      theme.name = nil
      expect(theme.valid?).to be false
      expect(theme.errors['name']).to include "can't be blank"
    end

    it "should be unique" do
      theme.name = FactoryGirl.create(:theme).name
      expect(theme.valid?).to be false
      expect(theme.errors['name']).to include "has already been taken"
    end
  end
end
