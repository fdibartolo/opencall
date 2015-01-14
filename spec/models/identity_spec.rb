require "rails_helper"

RSpec.describe Identity, :type => :model do
  describe "mandatory attributes" do
    %w[user_id provider uid].each do |attribute|
      it "should include #{attribute}" do
        identity = FactoryGirl.build(:identity)
        eval "identity.#{attribute} = nil"
        expect(identity.valid?).to be false
        expect(identity.errors[attribute]).to include "no puede estar en blanco"
      end
    end
  end  
end
