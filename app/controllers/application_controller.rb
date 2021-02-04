class ApplicationController < ActionController::Base
  include ApplicationHelper
  include DeviseHelper
  include RoomsHelper

  before_action :store_user_location!, if: :storable_location?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :profile_image])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile_image])
  end

  # 次の場合は、場所が保存されない
  # リクエストメソッドはGETではありません（べき等ではありません）
  # リクエストは、Devise :: SessionsControllerなどのDeviseコントローラーによって処理されます。
  # 無限のリダイレクトループ。
  # リクエストはAjaxリクエストです。これは、非常に予期しない動作につながる可能性があるためです。
  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end

  def redirect_back
    redirect_to(stored_location_for(:user) || root_path)
  end
end
