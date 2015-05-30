require 'rails_helper'

RSpec.describe MainController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET version" do
    it "returns just version when not commit_id" do
    	ENV['commit_id'] = nil
      get :version
      expect(response).to have_http_status(:success)
      expect(response.body).to include Version
    end

    it "returns version and commit_id when commit_id" do
    	commit_id = 'djsdfhksdfh82432342424'
    	ENV['commit_id'] = commit_id
      get :version
      expect(response).to have_http_status(:success)
      expect(response.body).to include Version
      expect(response.body).to include commit_id    
    end

  end

end
