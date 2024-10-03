class ApplicationController < ActionController::API
  private

  # Memeriksa apakah token valid
  def authenticate_request
    token = request.headers['Authorization']
    @current_user = User.find_by(auth_token: token)
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end
end
