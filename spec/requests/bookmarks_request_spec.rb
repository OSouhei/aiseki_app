require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  let(:user) { create(:user) }
  let(:room) { create(:room) }

  # Bookmarks#create
  describe "POST /rooms/:id/bookmark" do
    context "when authenticated user" do
      before do
        sign_in user
      end

      it "responds successfully" do
        post bookmark_room_path(room), xhr: true
        expect(response).to have_http_status 200
      end

      it "redirect to previous url" do
        post bookmark_room_path(room), xhr: true
        expect(response).to render_template partial: "bookmarks/_bookmark_icon"
      end

      it "create bookmark" do
        expect {
          post bookmark_room_path(room), xhr: true
        }.to change(Bookmark, :count).by(1)
      end

      it "return false if room is not found" do
        post bookmark_room_path(1000), xhr: true
        expect(response).to redirect_to root_path
      end
    end

    context "when guest" do
      it "redirect to login page" do
        post bookmark_room_path(room), xhr: true
        expect(response).to redirect_to new_user_session_path
      end

      it "does not create bookmark" do
        expect {
          post bookmark_room_path(room), xhr: true
        }.to_not change(Bookmark, :count)
      end
    end
  end
end
