require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "GET /users" do
    before do
      get users_path
    end

    it "responds successfully" do
      expect(response).to have_http_status 200
    end

    it "render template users/index" do
      expect(response).to render_template :index
    end
  end

  describe "GET /users/:id" do
    before do
      get user_path(user)
    end

    it "responds successfully" do
      expect(response).to have_http_status 200
    end

    it "render template users/show" do
      expect(response).to render_template :show
    end
  end
end
