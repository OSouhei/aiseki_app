class Users::SessionsController < Devise::SessionsController
  protect_from_forgery
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

  # DELETE /users/sign_out
  def destroy
    super do
      if request.format.json?
        render json: {
          csrf_param: request_forgery_protection_token,
          csrf_token: form_authenticity_token
        }
      end
    end
  end
end
