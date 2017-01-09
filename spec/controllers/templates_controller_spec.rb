require 'rails_helper'

RSpec.describe TemplatesController, :type => :controller do
  login_as :user

  %w[home error loading_spinner stats themes_list tweet
    sessions/index sessions/new sessions/search_result sessions/search_side_bar sessions/review
    sessions/comments sessions/actions sessions/reviews_summary sessions/show sessions/card
    users/faved_sessions users/reviews users/sessions users/voted_sessions users/profile_summary
    reports/reviewer_comments reports/reviews_status reports/session_votes.html.erb
    notifications/acceptance notifications/author_inbox
    menu/administration.html.erb menu/advanced_reports.html.erb
  ].each do |template|
    it "should serve the #{template} template" do
      get 'template', { path: template }
      expect(response).to be_success
      expect(response).to render_template template
    end
  end
end
