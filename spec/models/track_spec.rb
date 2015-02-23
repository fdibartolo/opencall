require "rails_helper"

RSpec.describe Track, :type => :model do
  describe "#name" do
    let(:track) { FactoryGirl.build(:track) }
    
    it "should be mandatory" do
      track.name = nil
      expect(track.valid?).to be false
      expect(track.errors['name']).to include "no puede estar en blanco"
    end

    it "should be unique" do
      track.name = FactoryGirl.create(:track).name
      expect(track.valid?).to be false
      expect(track.errors['name']).to include "ya ha sido tomado"
    end
  end
end
