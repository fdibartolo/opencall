require 'rails_helper'

RSpec.describe TemplatesController, :type => :controller do
  %w[home error loading_spinner
    sessions/index sessions/new sessions/search_result sessions/review
    users/faved_sessions users/reviews users/sessions users/voted_sessions
  ].each do |template|
    it "should serve the #{template} template" do
      get 'template', { path: template }
      expect(response).to be_success
      expect(response).to render_template template
    end
  end
end
