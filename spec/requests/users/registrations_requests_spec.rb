require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:user_params) { FactoryBot.attributes_for(:user) }
  let(:invalid_user_params) { FactoryBot.attributes_for(:user, name: "   ") }

  # Users::Registrations#create
  describe "POST /users" do
    context "when params is valid" do
      it "responds :created" do
        post user_registration_path, params: { user: user_params }
        expect(response).to have_http_status :created
      end

      it "render json" do
        post user_registration_path, params: { user: user_params }
        expect(response.content_type).to eq "application/json; charset=utf-8"
      end

      it "create user" do
        expect {
          post user_registration_path, params: { user: user_params }
        }.to change(User, :count).by(1)
      end

      # 送信したデータと帰ってきたデータが一致しているか？
      it "responds user data" do
        post user_registration_path, params: { user: user_params }
        user_data = JSON.parse(response.body)["result"]["user"]
        aggregate_failures do
          expect(user_data["name"]).to eq user_params[:name]
          expect(user_data["email"]).to eq user_params[:email]
        end
      end

      # アカウント登録後、ログインしているか？
      it "create session" do
        post user_registration_path, params: { user: user_params }
        expect(controller).to be_user_signed_in
      end
    end

    context "when params is invalid" do
      # ユーザーの作成に失敗した場合は400(bad request)を返す
      it "responds :bad_request" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response).to have_http_status :bad_request
      end

      it "render json" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(response.content_type).to eq "application/json; charset=utf-8"
      end

      it "does not create user" do
        expect {
          post user_registration_path, params: { user: invalid_user_params }
        }.to_not change(User, :count)
      end

      it "responds user data" do
        post user_registration_path, params: { user: invalid_user_params }
        user_data = JSON.parse(response.body)["result"]["user"]
        aggregate_failures do
          expect(user_data["name"]).to eq invalid_user_params[:name]
          expect(user_data["email"]).to eq invalid_user_params[:email]
        end
      end

      # エラーの内容をjsonで返す
      it "responds errors full_messages" do
        post user_registration_path, params: { user: invalid_user_params }
        errors = JSON.parse(response.body)["result"]["errors"]
        aggregate_failures do
          expect(errors.length).to eq 1
          expect(errors[0]).to eq "名前が入力されていません。"
        end
      end

      # ログインしていないか？
      it "does not create session" do
        post user_registration_path, params: { user: invalid_user_params }
        expect(controller).not_to be_user_signed_in
      end
    end
  end

  # describe "PATCH /users/" do
  #   context "when user signed in" do
  #     before do
  #       sign_in user
  #       patch user_registration_path, params: {
  #         user: {
  #           name: "New User",
  #           email: "new@example.com",
  #           password: "newpassword",
  #           password_confirmation: "newpassword",
  #           current_password: user.password
  #         }
  #       }
  #     end

  #     it "responds successfully" do
  #       expect(response).to have_http_status 302
  #     end

  #     it "redirect to user page" do
  #       expect(response).to redirect_to user_path(user)
  #     end

  #     it "update user" do
  #       user.reload
  #       aggregate_failures do
  #         expect(user.name).to eq "New User"
  #         expect(user.email).to eq "new@example.com"
  #         expect(user).to valid_password?("newpassword")
  #       end
  #     end
  #   end

  #   context "when user does not signed in" do
  #     before do
  #       patch user_registration_path, params: {
  #         user: {
  #           name: "New User",
  #           email: "new@example.com",
  #           password: "newpassword",
  #           password_confirmation: "newpassword",
  #           current_password: user.password
  #         }
  #       }
  #     end

  #     it "responds successfully" do
  #       expect(response).to have_http_status 302
  #     end

  #     it "redirect to sign in page" do
  #       expect(response).to redirect_to new_user_session_path
  #     end

  #     it "does not change user attributes" do
  #       aggregate_failures do
  #         expect(user.name).to_not eq "New User"
  #         expect(user.email).to_not eq "new@example.com"
  #         expect(user.password).to_not eq "newpassword"
  #       end
  #     end
  #   end
  # end

  # describe "DELETE /users" do
  #   context "when user signed in" do
  #     before do
  #       sign_in user
  #     end

  #     it "responds successfully" do
  #       delete user_registration_path
  #       expect(response).to have_http_status 302
  #     end

  #     it "redirect to home-page" do
  #       delete user_registration_path
  #       expect(response).to redirect_to root_path
  #     end

  #     it "destroy user" do
  #       expect {
  #         delete user_registration_path
  #       }.to change(User, :count).by(-1)
  #     end
  #   end

  #   context "when user does not signed in" do
  #     it "responds successfully" do
  #       delete user_registration_path
  #       expect(response).to have_http_status 302
  #     end

  #     it "redirect to login page" do
  #       delete user_registration_path
  #       expect(response).to redirect_to new_user_session_path
  #     end

  #     it "does not destroy user" do
  #       expect {
  #         delete user_registration_path
  #       }.to_not change(User, :count)
  #     end
  #   end
  # end
end
