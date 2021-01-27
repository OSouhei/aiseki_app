class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id]) || redirect_to(root_path, alert: "user is not found.") && return
    @rooms = @user.rooms
  end
end
