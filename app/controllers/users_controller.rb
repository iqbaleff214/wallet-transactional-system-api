class UsersController < ApplicationController
  before_action :authenticate_request

  def index
    query = params[:q]
    users = if query.present?
      User.includes(:wallet).where("name LIKE ? OR email LIKE ?", "%#{query}%", "%#{query}%")
    else
      User.includes(:wallet).all
    end

    render json: {
      data: users.as_json(only: [:name, :email], methods: :wallet_id)
    }, status: :ok
  end
end
