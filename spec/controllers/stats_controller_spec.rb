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
      FactoryGirl.create :review, session_proposal: first_session, user: logged_in(:admin)

      get :index

      body = JSON.parse response.body
      expect(body['themes'][0]['name']).to eq first_theme.name
      expect(body['themes'][0]['reviewed']).to eq 1
      expect(body['themes'][1]['name']).to eq second_theme.name
      expect(body['themes'][1]['reviewed']).to eq 0
    end
  end
end
