class RoomsController < ApplicationController
  before_action :set_user, only: [:new]
  before_action :authenticate_user!, only: [:new]

  def new
    redirect_to root_path and return unless current_user? @user
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
