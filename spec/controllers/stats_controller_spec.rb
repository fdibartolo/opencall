require 'rails_helper'

RSpec.describe StatsController, type: :controller do
  login_as :admin

  let!(:first_theme) { FactoryGirl.create :theme }
  let!(:second_theme) { FactoryGirl.create :theme, name: 'practices' }
  let!(:first_session) { FactoryGirl.create :session_proposal, theme: first_theme }
  let!(:second_session) { FactoryGirl.create :session_proposal, theme: first_theme, user: first_session.user }
  let!(:third_session) { FactoryGirl.create :session_proposal, theme: second_theme, user: first_session.user }

  describe "GET #index" do
    it "should return 2 themes with proposals count" do
      get :index

      body = JSON.parse response.body
      expect(body['themes'].count).to eq 2
      expect(body['themes'][0]['name']).to eq first_theme.name
      expect(body['themes'][0]['count']).to eq 2
      expect(body['themes'][1]['name']).to eq second_theme.name
      expect(body['themes'][1]['count']).to eq 1
    end

    it "should include how many have at least 1 review done" do
      FactoryGirl.create :review, session_proposal: first_session, user: logged_in

      get :index

      body = JSON.parse response.body
      expect(body['themes'][0]['name']).to eq first_theme.name
      expect(body['themes'][0]['reviewed']).to eq 1
      expect(body['themes'][1]['name']).to eq second_theme.name
      expect(body['themes'][1]['reviewed']).to eq 0
    end
  end

  describe "GET #show for given theme" do
    context "with invalid params id" do
      before :each do
        allow(Theme).to receive(:find_by).and_return(nil)
        get :show, { id: 9999 }
      end

      it "should return 400 Bad Request" do
        expect(response).to have_http_status(400)
      end

      it "should return 'cannot find' message" do
        expect(response.header['Message']).to eq "Unable to find theme with id '9999'"
      end
    end

    context "with valid params" do
      it "should return proposals list" do
        get :show, { id: first_theme.id }

        body = JSON.parse response.body
        expect(body['name']).to eq first_theme.name
        expect(body['proposals'].count).to eq 2
        expect(body['proposals'][0]['title']).to eq first_session.title
        expect(body['proposals'][1]['title']).to eq second_session.title
      end

      it "should include reviews score for each proposal" do
        FactoryGirl.create :review, score: 9, session_proposal: first_session, user: logged_in

        get :show, { id: first_theme.id }

        body = JSON.parse response.body
        expect(body['proposals'].count).to eq 2
        expect(body['proposals'][0]['reviews']).to eq [9]
        expect(body['proposals'][1]['reviews']).to eq []
      end
    end
  end
end
