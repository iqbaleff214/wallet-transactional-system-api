class StocksController < ApplicationController
  before_action :authenticate_request

  def index
    query = params[:q]
    stocks = if query.present?
      Stock.includes(:wallet).where("name LIKE ?", "%#{query}%")
    else
      Stock.includes(:wallet).all
    end

    render json: {
      data: stocks.as_json(only: [:name, :quantity, :price], methods: [:wallet_id, :current_balance])
    }, status: :ok
  end
end
