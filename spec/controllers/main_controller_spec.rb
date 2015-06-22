require 'rails_helper'

RSpec.describe MainController, :type => :controller do

  describe "GET index" do
    context "while guest user" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    context "while user logged in" do
      login_as :user

      context "has no proposals submitted" do
        it "returns http success" do
          get :index
          expect(response).to have_http_status(:success)
        end
      end

      context "has proposals submitted and" do
        let!(:session) { FactoryGirl.create :session_proposal, user: logged_in }

        context "bio is filled out" do
          it "returns http success" do
            session.user.bio = 'my bio'
            session.user.save!

            get :index
            expect(response).to have_http_status(:success)
          end
        end

        context "bio is missing" do
          it "redirects to user profile page" do
            get :index
            expect(response).to redirect_to edit_user_registration_path
          end

          it "displays 'update bio' message" do
            get :index
            expect(request.flash[:alert]).to include I18n.t('flash.missing_bio')
          end
        end
      end
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
