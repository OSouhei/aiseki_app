class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:joining, :follow, :unfollow]
  before_action :set_user, only: [:show, :joining, :follow, :unfollow]

  def index
    @users = User.page(params[:page]).per(9)
  end

  def show
    @rooms = @user.rooms
  end

  # GET /users/:id/joining
  def joining
    redirect_to(root_path, alert: "you can not access this page.") unless current_user?(@user)
    @rooms = @user.joining.page(params[:page]).per(10)
  end

  # GET /users/:id/follow
  def follow
    current_user.follow @user
  end

  # GET /users/:id/unfollow
  def unfollow
    current_user.unfollow @user
    render "users/follow"
  end

  private

  def set_user
    @user = User.find_by(id: params[:id]) || redirect_to(root_path, alert: "user is not found.") && return
  end

  def authenticate_user!
    redirect_to(new_user_session_path, alert: "you need to sign in or sign up before continuing.") unless current_user
  end
end
