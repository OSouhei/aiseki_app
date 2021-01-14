require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  let(:user) { FactoryBot.create(:user) }
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

  describe "GET /users/edit" do
    context "when user signed in" do
      before do
        sign_in user
        get edit_user_registration_path
      end

      it "responds successfully" do
        expect(response).to have_http_status 200
      end

      it "render template users/registrations/edit" do
        expect(response).to render_template :edit
      end
    end

    context "when user does not signed in" do
      before do
        get edit_user_registration_path
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to sign_in page" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "PATCH /users/" do
    context "when user signed in" do
      before do
        sign_in user
        patch user_registration_path, params: {
          user: {
            name: "New User",
            email: "new@example.com",
            password: "newpassword",
            password_confirmation: "newpassword",
            current_password: user.password
          }
        }
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home-page" do
        expect(response).to redirect_to root_path
      end

      it "update user" do
        user.reload
        aggregate_failures do
          expect(user.name).to eq "New User"
          expect(user.email).to eq "new@example.com"
          expect(user).to valid_password?("newpassword")
        end
      end
    end

    context "when user does not signed in" do
      before do
        patch user_registration_path, params: {
          user: {
            name: "New User",
            email: "new@example.com",
            password: "newpassword",
            password_confirmation: "newpassword",
            current_password: user.password
          }
        }
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to sign in page" do
        expect(response).to redirect_to new_user_session_path
      end

      it "does not change user attributes" do
        aggregate_failures do
          expect(user.name).to_not eq "New User"
          expect(user.email).to_not eq "new@example.com"
          expect(user.password).to_not eq "newpassword"
        end
      end
    end
  end

  describe "DELETE /users" do
    context "when user signed in" do
      before do
        sign_in user
      end

      it "responds successfully" do
        delete user_registration_path
        expect(response).to have_http_status 302
      end

      it "redirect to home-page" do
        delete user_registration_path
        expect(response).to redirect_to root_path
      end

      it "destroy user" do
        expect {
          delete user_registration_path
        }.to change(User, :count).by(-1)
      end
    end

    context "when user does not signed in" do
      it "responds successfully" do
        delete user_registration_path
        expect(response).to have_http_status 302
      end

      it "redirect to login page" do
        delete user_registration_path
        expect(response).to redirect_to new_user_session_path
      end

      it "does not destroy user" do
        expect {
          delete user_registration_path
        }.to_not change(User, :count)
      end
    end
  end
end
