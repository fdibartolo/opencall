require "rails_helper"

RSpec.describe Role, :type => :model do
  describe "#name" do
    let(:role) { FactoryGirl.build(:role) }
    
    it "should be mandatory" do
      role.name = nil
      expect(role.valid?).to be false
      expect(role.errors['name']).to include "no puede estar en blanco"
    end

    it "should be unique" do
      FactoryGirl.create(:role)
      expect(role.valid?).to be false
      expect(role.errors['name']).to include "ya ha sido tomado"
    end
  end
end
