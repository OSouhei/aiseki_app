class Users::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery

  # POST /users
  def create
    super do
      render json: {
        status: 'ok',
        csrf_token: form_authenticity_token,
        result: {
          user: {
            id: @user.id,
            name: @user.name,
            email: @user.email
          }
        }
      } and return
    end
  end
end
