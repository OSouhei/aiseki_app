class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:joining]
  before_action :set_user, only: [:show, :joining]

  def index
    @users = User.all
  end

  def show
    @rooms = @user.rooms
  end

  # GET /users/:id/joining
  def joining
    redirect_to(root_path, alert: "you can not access this page.") unless current_user?(@user)
    @rooms = @user.joining
  end

  private

  def set_user
    @user = User.find_by(id: params[:id]) || redirect_to(root_path, alert: "user is not found.") && return
  end
end
