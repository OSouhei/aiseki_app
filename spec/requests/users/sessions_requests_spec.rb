require 'rails_helper'

RSpec.describe "SessionsRequests", type: :request do
  let(:user) { FactoryBot.create(:user) }

  # Users::Sessions#create
  describe "POST /users/sign_in" do
    context "when params is valid" do
      before do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
      end

      it "responds :ok" do
        expect(response).to have_http_status :ok
      end

      it "render json" do
        expect(response.content_type).to eq "application/json; charset=utf-8"
      end

      it "responds user data" do
        user_data = JSON.parse(response.body)["result"]["user"]
        aggregate_failures do
          expect(user_data["id"]).to eq user.id
          expect(user_data["name"]).to eq user.name
          expect(user_data["email"]).to eq user.email
        end
      end

      it "define current_user" do
        aggregate_failures do
          expect(controller.current_user.name).to eq user.name
          expect(controller.current_user.email).to eq user.email
        end
      end

      it "create session" do
        expect(controller).to be_user_signed_in
      end
    end

    context "when params is invalid" do
      before do
        post user_session_path, params: { user: { email: "   ", password: "   " } }
      end

      it "responds :bad_request" do
        expect(response).to have_http_status :bad_request
      end

      it "render json" do
        expect(response.content_type).to eq "application/json; charset=utf-8"
      end

      it "responds user data as nil" do
        user_data = JSON.parse(response.body)["result"]["user"]
        expect(user_data).to be_nil
      end

      it "does not define current_user" do
        variable = controller.instance_variable_get("@user")
        expect(variable).to be_nil
      end

      it "does not create session" do
        expect(controller).not_to be_user_signed_in
      end
    end
  end

  # Users::Sessions#destroy
  describe "DELETE /users/sign_out" do
    context "when user is log in" do
      before do
        sign_in user
        delete destroy_user_session_path
      end

      it "responds :ok" do
        expect(response).to have_http_status :ok
      end

      it "render json" do
        expect(response.content_type).to eq "application/json; charset=utf-8"
      end

      it "logout" do
        expect(controller).not_to be_user_signed_in
      end
    end

    context "when user is not log in" do
      before do
        delete destroy_user_session_path
      end

      it "responds error" do
        expect(response).to have_http_status :found
      end

      it "redirect to top page" do
        expect(response).to redirect_to root_path
      end

      it "log out" do
        expect(controller).not_to be_user_signed_in
      end
    end
  end
end
