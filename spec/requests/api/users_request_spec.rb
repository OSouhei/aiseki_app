require 'rails_helper'

RSpec.describe "Api::Users", type: :request do
  let(:user) { create(:user) }

  # Api::Users#index
  describe "GET /api/users" do
    before do
      get api_users_path
    end

    it "responds :ok" do
      expect(response).to have_http_status :ok
    end

    it "render json" do
      expect(response.content_type).to eq "application/json; charset=utf-8"
    end

    it "has users data" do
      10.times { |n| create(:user, email: "test-#{n}@test.com") } # 10人ユーザーを作成
      get api_users_path # リクエスト送信
      users_data = JSON.parse(response.body)["result"]
      aggregate_failures do
        expect(users_data.length).to eq 10 # 人数分のデータがあるか？
        expect(users_data[0]["email"]).to eq User.first.email # 最初のデータは最初のユーザーのデータか？
      end
    end
  end

  # Api::Users#show
  describe "GET /api/users/:id" do
    before do
      get api_user_path(user)
    end

    it "responds :ok" do
      expect(response).to have_http_status :ok
    end

    it "render json" do
      expect(response.content_type).to eq "application/json; charset=utf-8"
    end

    it "has user data" do
      user_data = JSON(response.body)["user"]
      aggregate_failures do
        expect(user_data["id"]).to eq user.id
        expect(user_data["name"]).to eq user.name
        expect(user_data["email"]).to eq user.email
      end
    end
  end

  # Api;;Users#login_user
  describe "GET /api/login_user" do
    before do
      get api_login_user_path
    end

    it "responds :ok" do
      expect(response).to have_http_status :ok
    end

    it "render json" do
      expect(response.content_type).to eq "application/json; charset=utf-8"
    end

    context "when user is log in" do
      before do
        sign_in user
        get api_login_user_path
      end

      it "has current_user data" do
        user_data = JSON.parse(response.body)
        aggregate_failures do
          expect(user_data["id"]).to eq user.id
          expect(user_data["name"]).to eq user.name
          expect(user_data["email"]).to eq user.email
        end
      end
    end

    context "when user is not log in" do
      # ログインしていない場合データは空か？
      it "has no data" do
        user_data = JSON.parse(response.body)
        expect(user_data).to be_blank
      end
    end
  end
end
