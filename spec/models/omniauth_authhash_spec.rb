require 'rails_helper'

RSpec.describe OmniAuth::AuthHash do
  describe "#first_name_or_default" do
    it "should return first_name if present" do
      auth = OmniAuth::AuthHash.new({ :info => { name: 'First Last', first_name: 'FirstName', email: 'user@mail.com' }})
      expect(auth.first_name_or_default).to eq 'FirstName'
    end

    it "should parse name if first_name is not present" do
      auth = OmniAuth::AuthHash.new({ :info => { name: 'First Last', email: 'user@mail.com' }})
      expect(auth.first_name_or_default).to eq 'First'
    end

    it "should return default if first_name nor name are present" do
      auth = OmniAuth::AuthHash.new({ :info => { name: '', email: 'user@mail.com' }})
      expect(auth.first_name_or_default).to eq 'first name'
    end
  end

  describe "#last_name_or_default" do
    it "should return last_name if present" do
      auth = OmniAuth::AuthHash.new({ :info => { name: 'First Last', last_name: 'LastName', email: 'user@mail.com' }})
      expect(auth.last_name_or_default).to eq 'LastName'
    end

    it "should parse name if last_name is not present" do
      auth = OmniAuth::AuthHash.new({ :info => { name: 'First Last', email: 'user@mail.com' }})
      expect(auth.last_name_or_default).to eq 'Last'
    end

    it "should return default if last_name nor name are present" do
      auth = OmniAuth::AuthHash.new({ :info => { name: 'First', email: 'user@mail.com' }})
      expect(auth.last_name_or_default).to eq 'last name'
    end
  end
end
