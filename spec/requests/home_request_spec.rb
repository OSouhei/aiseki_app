require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /" do
    before do
      get root_path
    end

    it "responds successfully" do
      expect(response).to have_http_status 200
    end

    it "render template home/index" do
      expect(response).to render_template :index
    end
  end
end
