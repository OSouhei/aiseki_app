require 'rails_helper'

RSpec.describe "SessionsRequests", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "GET /users/sign_in" do
    before do
      get new_user_session_path
    end

    it "responds successfully" do
      expect(response).to have_http_status 200
    end

    it "render template sessions/new" do
      expect(response).to render_template :new
    end
  end

  describe "POST /users/sign_in" do
    context "when params is valid" do
      before do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home-page" do
        expect(response).to redirect_to root_path
      end
    end

    context "when params is invalid" do
      before do
        post user_session_path, params: { user: { email: "   ", password: "   " } }
      end

      it "responds successfully" do
        expect(response).to have_http_status 200
      end

      it "render template sessions/new" do
        expect(response).to render_template :new
      end
    end
  end
end
