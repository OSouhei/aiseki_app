class Users::SessionsController < Devise::SessionsController
  protect_from_forgery

  # POST /users/sign_in
  def create
    @user = current_user
    render(json: data_of(@user), status: 400) and return unless @user

    super do
      render(json: data_of(@user), status: 200) and return
    end
  end

  # DELETE /users/sign_out
  def destroy
    super do
      render json: {
        csrf_param: request_forgery_protection_token,
        csrf_token: form_authenticity_token
      }, status: 200 and return
    end
  end

  private

  def data_of(user)
    user_data = user ? { id: user.id, name: user.name, email: user.email } : nil
    {
      csrf_token: form_authenticity_token,
      result: {
        user: user_data
      }
    }
  end
end
