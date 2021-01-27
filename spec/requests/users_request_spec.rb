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
    it "responds successfully" do
      get user_path(user)
      expect(response).to have_http_status 200
    end

    it "render template users/show" do
      get user_path(user)
      expect(response).to render_template :show
    end

    context "when user is not found" do
      it "responds successfully" do
        get user_path(user.id + 1000)
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        get user_path(user.id + 1000)
        expect(response).to redirect_to root_path
      end
    end
  end
end
