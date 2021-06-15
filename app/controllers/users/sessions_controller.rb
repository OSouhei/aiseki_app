class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # POST /users/sign_in
  def create
    @user = current_user
    super do
      if request.format.json?
        render json: {
          status: 'ok',
          csrf_token: 'form_authenticity_token',
          result: {
            user: {
              id: @user.id
            }
          }
        }
      end
    end
  end
end
