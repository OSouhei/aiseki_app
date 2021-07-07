require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:room) { create(:room, owner: user) }
  let(:room_params) { attributes_for(:room) }
  let(:new_room_params) { attributes_for(:new_room) }
  let(:invalid_room_params) {
    attributes_for(:room, {
                     title: "",
                     shop_name: ""
                   })
  }

  # Rooms#index
  describe "GET /rooms" do
    before do
      get rooms_path
    end

    it "responds :ok" do
      expect(response).to have_http_status :ok
    end

    it "render json" do
      expect(response).to have_content_type_json
    end

    it "has rooms data" do
      create_list(:room, 10, owner: user)
      get rooms_path
      rooms_data = JSON.parse(response.body)["result"]["rooms"]
      expect(rooms_data.length).to eq 10
    end
  end

  # Rooms#show
  describe "GET /rooms/:id" do
    before do
      get room_path(room)
    end

    it "responds :ok" do
      expect(response).to have_http_status :ok
    end

    it "render json" do
      expect(response).to have_content_type_json
    end

    it "has room data" do
      room_data = JSON.parse(response.body)["result"]
      aggregate_failures do
        expect(room_data["room"]["id"]).to eq room.id
        expect(room_data["room"]["title"]).to eq room.title
        expect(room_data["room"]["content"]).to eq room.content
        expect(room_data["room"]["date"]).to be_same_date_time(room.date)
        expect(room_data["room"]["limit"]).to eq room.limit
        expect(room_data["room"]["shop_name"]).to eq room.shop_name
      end
    end
  end

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
            expect(room_data["date"]).to be_same_date_time(room_params[:date])
            expect(room_data["limit"]).to eq room_params[:limit]
          end
        end
      end

      # パラメータが不正な場合
      context "when room params id invalid" do
        before do
          sign_in user
        end

        it "responds :ok" do
          post rooms_path, params: { room: invalid_room_params }
          expect(response).to have_http_status :bad_request
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
          err = JSON.parse(response.body)["result"]["errors"]
          expect(err.length).to eq 2
        end

        it "has error messages data" do
          post rooms_path, params: { room: invalid_room_params }
          err = JSON.parse(response.body)["result"]["errors"]
          aggregate_failures do
            expect(err[0]).to eq "ルーム名を入力してください"
            expect(err[1]).to eq "店名を入力してください"
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

  # Rooms#update
  describe "PATCH /rooms/:id" do
    # ユーザーがログインしている場合
    context "when user is logged in" do
      # パラメータが正しい場合
      context "when params is valid" do
        before do
          sign_in user
          patch room_path(room), params: { room: new_room_params }
        end

        it "responds :ok" do
          expect(response).to have_http_status :ok
        end

        it "render json" do
          expect(response).to have_content_type_json
        end

        it "update room" do
          room.reload
          aggregate_failures do
            expect(room.title).to eq new_room_params[:title]
            expect(room.content).to eq new_room_params[:content]
            expect(room.limit).to eq new_room_params[:limit]
            expect(room.shop_name).to eq new_room_params[:shop_name]
          end
        end

        it "responds room data" do
          room_data = JSON.parse(response.body)["result"]["room"]
          room.reload
          aggregate_failures do
            expect(room_data["id"]).to eq room.id
            expect(room_data["title"]).to eq room.title
            expect(room_data["content"]).to eq room.content
            expect(room_data["limit"]).to eq room.limit
            expect(room_data["shop_name"]).to eq room.shop_name
          end
        end
      end

      # パラメータが不正な場合
      context "when params invalid" do
        before do
          sign_in user
          patch room_path(room), params: { room: invalid_room_params }
        end

        it "responds :bad_request" do
          expect(response).to have_http_status :bad_request
        end

        it "render json" do
          expect(response).to have_content_type_json
        end

        it "does not update room" do
          room.reload
          aggregate_failures do
            expect(room.title).to_not eq invalid_room_params[:title]
            expect(room.shop_name).to_not eq invalid_room_params[:shop_name]
          end
        end

        it "have error data" do
          error_data = JSON.parse(response.body)["errors"]
          expect(error_data.length).to eq 2
        end

        it "have error messages" do
          error_data = JSON.parse(response.body)["errors"]
          aggregate_failures do
            expect(error_data[0]).to eq "ルーム名を入力してください"
            expect(error_data[1]).to eq "店名を入力してください"
          end
        end
      end

      context "when other user" do
        before do
          sign_in other_user
          patch room_path(room), params: { room: new_room_params }
        end

        it "responds :found" do
          expect(response).to have_http_status :found
        end

        it "redirect to top page" do
          expect(response).to redirect_to root_path
        end

        it "does not update room" do
          room.reload
          aggregate_failures do
            expect(room.title).to_not eq new_room_params[:title]
            expect(room.content).to_not eq new_room_params[:content]
            expect(room.limit).to_not eq new_room_params[:limit]
            expect(room.shop_name).to_not eq new_room_params[:shop_name]
          end
        end
      end

      context "when guest user" do
        before do
          patch room_path(room), params: { room: new_room_params }
        end

        it "responds :found" do
          expect(response).to have_http_status :found
        end

        it "does not update room" do
          room.reload
          aggregate_failures do
            expect(room.title).to_not eq new_room_params[:title]
            expect(room.content).to_not eq new_room_params[:content]
            expect(room.limit).to_not eq new_room_params[:limit]
            expect(room.shop_name).to_not eq new_room_params[:shop_name]
          end
        end
      end
    end
  end

  # Rooms#destroy
  describe "DELETE /rooms/:id" do
    # ユーザーがログインしている場合
    context "when user is logged in" do
      before do
        sign_in user
      end

      it "responds :ok" do
        delete room_path(room)
        expect(response).to have_http_status :ok
      end

      it "render json" do
        delete room_path(room)
        expect(response).to have_content_type_json
      end

      it "destroy room" do
        room
        expect {
          delete room_path(room)
        }.to change(Room, :count).by(-1)
      end
    end

    context "when other user" do
      before do
        sign_in other_user
      end

      it "responds :found" do
        delete room_path(room)
        expect(response).to have_http_status :found
      end

      it "redirect to top page" do
        delete room_path(room)
        expect(response).to redirect_to root_path
      end

      it "does not destroy room" do
        room
        expect {
          delete room_path(room)
        }.to_not change(Room, :count)
      end
    end

    context "when user is not logged in" do
      it "responds :found" do
        delete room_path(room)
        expect(response).to have_http_status :found
      end

      it "redirect to top page" do
        delete room_path(room)
        expect(response).to redirect_to root_path
      end

      it "does not destroy room" do
        room
        expect {
          delete room_path(room)
        }.to_not change(Room, :count)
      end
    end
  end
end
