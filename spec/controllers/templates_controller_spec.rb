require 'rails_helper'

RSpec.describe TemplatesController, :type => :controller do
  %w[
    home
  ].each do |template|
    it "should serve the #{template} template" do
      get 'template', { path: template }
      expect(response).to be_success
      expect(response).to render_template template
    end
  end
end
