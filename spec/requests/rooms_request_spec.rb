require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  let(:user) { create(:user) }
  let(:room_params) { attributes_for(:room) }
  let(:invalid_room_params) {
    attributes_for(:room, {
                     title: "",
                     shop_name: ""
                   })
  }

  # Rooms#create
  describe "POST /rooms" do
    # ユーザーがログインしている場合
    context "when user is logged in" do
      # パラメータが正しい場合
      context "when rooms params is valid" do
        before do
          sign_in user
        end

        it "responds :ok" do
          post rooms_path, params: { room: room_params }
          expect(response).to have_http_status :ok
        end

        it "render json" do
          post rooms_path, params: { room: room_params }
          expect(response).to have_content_type_json
        end

        it "create room" do
          expect {
            post rooms_path, params: { room: room_params }
          }.to change(Room, :count).by(1)
        end

        it "has room data" do
          post rooms_path, params: { room: room_params }
          room_data = JSON.parse(response.body)["result"]["room"]
          aggregate_failures do
            expect(room_data["title"]).to eq room_params[:title]
            expect(room_data["content"]).to eq room_params[:content]
            expect(room_data["shop_name"]).to eq room_params[:shop_name]
            # 後で日付だけを登録するようにする
            # expect(room_data["date"]).to eq room_params[:date]
            expect(room_data["limit"]).to eq room_params[:limit]
          end
        end
      end

      context "when room params id invalid" do
        before do
          sign_in user
        end

        it "responds :ok" do
          post rooms_path, params: { room: invalid_room_params }
          expect(response).to have_http_status :ok
        end

        it "render json" do
          post rooms_path, params: { room: invalid_room_params }
          expect(response).to have_content_type_json
        end

        it "does not create room" do
          expect {
            post rooms_path, params: { room: invalid_room_params }
          }.to_not change(Room, :count)
        end

        it "has error data" do
          post rooms_path, params: { room: invalid_room_params }
          err = JSON.parse(response.body)["errors"]
          expect(err.length).to eq 2
        end

        # 後で日本語化する。。。
        it "has error messages data" do
          post rooms_path, params: { room: invalid_room_params }
          err = JSON.parse(response.body)["errors"]
          aggregate_failures do
            expect(err[0]).to eq "Titleを入力してください"
            expect(err[1]).to eq "Shop nameを入力してください"
          end
        end
      end
    end

    # ユーザーがログインしていない場合
    context "when user is not logged in" do
      it "responds :found" do
        post rooms_path, params: { room: room_params }
        expect(response).to have_http_status :found
      end

      it "redirect to top page" do
        post rooms_path, params: { room: room_params }
        expect(response).to redirect_to root_path
      end

      it "does not create room" do
        expect {
          post rooms_path, params: { room: room_params }
        }.to_not change(Room, :count)
      end
    end
  end
end
