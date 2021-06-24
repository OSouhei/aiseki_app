class Users::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery

  # POST /users
  def create
    super do
      err = @user.errors.full_messages
      sign_in(@user, event: :authentication) if err.empty? # エラーがなければログイン
      http_status = err.empty? ? :created : :bad_request # ユーザー作成の結果に応じてステータスコードを返す
      render json: {
        csrf_token: form_authenticity_token,
        result: {
          errors: err,
          user: { id: @user.id, name: @user.name, email: @user.email }
        }
      }, status: http_status and return
    end
  end
end
