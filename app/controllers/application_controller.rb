class ApplicationController < ActionController::Base
  include DeviseHelper
  include RoomsHelper

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  # params に :id, :user_id が両方あるときは使わない
  def set_user
    @user = User.find_by(id: params[:id]) || User.find_by(id: params[:user_id]) || redirect_to(root_path, alert: "user is not found.") and return
  end
end
