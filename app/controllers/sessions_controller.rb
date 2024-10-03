class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      token = user.generate_auth_token
      render json: { token: token, message: 'Login successful' }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    user = User.find_by(auth_token: request.headers['Authorization'])
    if user
      user.update(auth_token: nil)
      render json: { message: 'Logout successful' }, status: :ok
    else
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end
end
