require 'rails_helper'

RSpec.describe MainController, :type => :controller do

  describe "GET index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET version" do
    it "returns just version when not commit" do
      get :version
      expect(response).to have_http_status(:success)
      expect(response.body).to include Version
    end

    it "returns version and commit_id when commit_id" do
    	commit_id = 'djsdfhksdfh82432342424'
      path = File.expand_path('../../../public/commit_track.txt', __FILE__)
      f = File.new(path, "w")
      f.write(commit_id)
      f.close  
      get :version
      expect(response).to have_http_status(:success)
      expect(response.body).to include Version
      expect(response.body).to include commit_id    
      File.delete(path)
    end

  end

end
