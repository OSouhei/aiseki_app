require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  let(:user_params) { FactoryBot.attributes_for(:user) }
  let(:invalid_user_params) { FactoryBot.attributes_for(:user, name: "   ") }

  describe "GET /users/sign_up" do
    before do
      get new_user_registration_path
    end

    it "responds successfully" do
      expect(response).to have_http_status 200
    end

    it "render template registrations/new" do
      expect(response).to render_template :new
    end
  end

  describe "POST /users" do
    context "when params is valid" do
      before do
        post user_registration_path, params: { user: user_params }
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
        post user_registration_path, params: { user: invalid_user_params }
      end

      it "responds successfully" do
        expect(response).to have_http_status 200
      end

      it "render template registration/new" do
        expect(response).to render_template :new
      end
    end
  end
end
