class TeamsController < ApplicationController
  before_action :authenticate_request

  def index
    query = params[:q]
    teams = if query.present?
      Team.includes(:wallet).where("name LIKE ?", "%#{query}%")
    else
      Team.includes(:wallet).all
    end

    render json: {
      data: teams.as_json(only: [:name], methods: :wallet_id)
    }, status: :ok
  end
end
