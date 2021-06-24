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

  # Users::Registrations#update
  describe "PATCH /users" do
    let(:new_user_params) {
      attributes_for(:user, {
                       name: "new name",
                       email: "new@example.com",
                       password: "newpassword",
                       password_confirmation: "newpassword",
                       current_password: "password"
                     })
    }

    # ユーザーがログインしている場合
    context "when user is logged in" do
      # 正しい値
      context "with valid params" do
        before do
          sign_in user
          patch user_registration_path, params: {
            user: new_user_params
          }
        end

        it "responds successfully" do
          expect(response).to have_http_status :ok
        end

        it "render json" do
          expect(response).to have_content_type_json
        end

        it "has user data" do
          user_data = JSON.parse(response.body)["result"]["user"]
          aggregate_failures do
            expect(user_data["name"]).to eq new_user_params[:name]
            expect(user_data["email"]).to eq new_user_params[:email]
          end
        end

        it "update user attributes" do
          user.reload
          aggregate_failures do
            expect(user.name).to eq new_user_params[:name]
            expect(user.email).to eq new_user_params[:email]
            expect(user).to valid_password? new_user_params[:password]
          end
        end

        it "user log in" do
          expect(controller).to be_user_signed_in
        end
      end

      # 不正な値
      context "with invalid params" do
        let(:invalid_new_user_params) {
          attributes_for(:user, {
                           name: " ",
                           email: " ",
                           password: " ",
                           password_confirmation: " ",
                           current_password: " "
                         })
        }

        before do
          sign_in user
          patch user_registration_path, params: {
            user: invalid_new_user_params
          }
        end

        it "responds :bad_request" do
          expect(response).to have_http_status :bad_request
        end

        it "render json" do
          expect(response).to have_content_type_json
        end

        it "has error data" do
          err = JSON.parse(response.body)["result"]["errors"]
          expect(err.length).to eq 4
        end

        it "does not update user attributes" do
          old_user = user
          user.reload
          aggregate_failures do
            expect(user.name).to eq old_user.name
            expect(user.email).to eq old_user.email
            expect(user).to valid_password? old_user.password
          end
        end

        it "is logged in" do
          expect(controller).to be_user_signed_in
        end
      end
    end

    # ユーザーがログインしていない場合
    context "when user is not logged in" do
      before do
        patch user_registration_path, params: {
          user: new_user_params
        }
      end

      it "responds :found" do
        expect(response).to have_http_status :found
      end

      it "redirect to top page" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
