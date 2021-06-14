class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  # POST /users
  def create
    super do
      if request.format.json?
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
        }
      end
    end
  end
end
