require "rails_helper"

RSpec.describe Track, :type => :model do
  describe "#name" do
    let(:track) { FactoryGirl.build(:track) }
    
    it "should be mandatory" do
      track.name = nil
      expect(track.valid?).to be false
      expect(track.errors['name']).to include "can't be blank"
    end

    it "should be unique" do
      track.name = FactoryGirl.create(:track).name
      expect(track.valid?).to be false
      expect(track.errors['name']).to include "has already been taken"
    end
  end
end
