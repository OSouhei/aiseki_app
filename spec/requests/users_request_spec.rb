require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  # Users#index
  describe "GET /users" do
    before do
      get users_path
    end

    it "responds successfully" do
      expect(response).to have_http_status 200
    end

    it "render template users/index" do
      expect(response).to render_template :index
    end
  end

  # Users#show
  describe "GET /users/:id" do
    it "responds successfully" do
      get user_path(user)
      expect(response).to have_http_status 200
    end

    it "render template users/show" do
      get user_path(user)
      expect(response).to render_template :show
    end

    context "when user is not found" do
      it "responds successfully" do
        get user_path(user.id + 1000)
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        get user_path(user.id + 1000)
        expect(response).to redirect_to root_path
      end
    end
  end

  # Users#joining
  describe "GET /users/:id/joining" do
    context "when authenticated user" do
      before do
        sign_in user
        get joining_user_path(user)
      end

      it "responds successfully" do
        expect(response).to have_http_status 200
      end

      it "render template users/joining" do
        expect(response).to render_template :joining
      end
    end

    context "when unathenticated user" do
      before do
        sign_in other_user
        get joining_user_path(user)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end
    end

    context "when guest" do
      before do
        get joining_user_path(user)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to login page" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when user is not found" do
      before do
        sign_in user
        get joining_user_path(user.id + 1000)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end
    end
  end

  # Users#follow
  context "GET /users/:id/follow" do
    context "when authenticated user" do
      before do
        sign_in user
        get follow_user_path(other_user), xhr: true
      end

      it "responds successfully" do
        expect(response).to have_http_status 200
      end

      it "render template follow.js.erb" do
        expect(response).to render_template "users/follow"
      end

      it "define @user" do
        variable = controller.instance_variable_get "@user"
        expect(variable).to eq other_user
      end

      context "when user is not found" do
        before do
          get follow_user_path(1000), xhr: true
        end

        it "redirect root_path" do
          expect(response).to redirect_to root_path
        end

        it "define flash" do
          expect(flash[:alert]).to eq "user is not found."
        end
      end
    end

    context "when user have already followed other_user" do
      before do
        user.follow other_user
        sign_in user
        get follow_user_path(other_user), xhr: true
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect user page" do
        expect(response).to redirect_to user_path(other_user)
      end

      it "define flash" do
        expect(flash[:alert]).to eq "you have already followed the user."
      end
    end

    context "when guest" do
      before do
        get follow_user_path(other_user), xhr: true
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect_to login page" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  # Users#unfollow
  context "GET /users/:id/unfollow" do
    context "when authenticated user" do
      before do
        sign_in user
        get unfollow_user_path(other_user), xhr: true
      end

      it "responds successfully" do
        expect(response).to have_http_status 200
      end

      it "render template follow.js.erb" do
        expect(response).to render_template "users/follow"
      end

      it "define @user" do
        variable = controller.instance_variable_get "@user"
        expect(variable).to eq other_user
      end
    end

    context "when guest" do
      before do
        get unfollow_user_path(other_user), xhr: true
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect_to login page" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
