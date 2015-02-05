require "rails_helper"

RSpec.describe Tag, :type => :model do
  let(:tag) { FactoryGirl.build(:tag) }

  describe "#as_indexed_json" do
    it { expect(tag.as_indexed_json['name']).to eq tag.name }
  end

  describe "from elasticsearch", :elasticsearch do
    let(:first_tag) { FactoryGirl.create :tag, name: 'lean' }
    let(:second_tag) { FactoryGirl.create :tag, name: 'scrum' }
    let(:third_tag) { FactoryGirl.create :tag, name: 'scrumban' }

    before :each do
      first_tag.__elasticsearch__.index_document
      second_tag.__elasticsearch__.index_document
      third_tag.__elasticsearch__.index_document
      Tag.__elasticsearch__.refresh_index!
    end

    context "all" do
      it "should return three documents" do
        expect(Tag.search_all.results.total).to eq 3
      end
    end

    context "suggest" do
      it "should return 2 matching documents" do
        expect(Tag.suggest('scru').count).to eq 2
      end
    end
  end
end