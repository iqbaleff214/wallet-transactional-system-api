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
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def show_price_all
    stock_price_service = LatestStockPrice.new
    all_prices = stock_price_service.price_all
    render json: all_prices, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
end
