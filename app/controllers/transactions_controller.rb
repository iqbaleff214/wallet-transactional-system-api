class TransactionsController < ApplicationController
  before_action :authenticate_request
  before_action :validate_amount, only: [:debit, :credit, :transfer]

  def show
    wallet = @current_user.wallet
    render json: {
      status: 'OK',
      data: wallet.as_json(only: [:id, :balance, :created_at, :updated_at]),
    }
  end

  def debit
    wallet = @current_user.wallet
    amount = params[:amount].to_i

    if wallet.balance < amount
      render json: { error: 'Insufficient balance' }, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      Transaction.create!(
        source_wallet: wallet,
        target_wallet: nil,
        amount: amount,
        transaction_type: 'debit'
      )

      wallet.update!(balance: wallet.balance - amount)
    end

    render json: { message: 'Withdraw successful', balance: wallet.balance }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def credit
    wallet = @current_user.wallet
    amount = params[:amount].to_i

    ActiveRecord::Base.transaction do
      Transaction.create!(
        source_wallet: nil,
        target_wallet: wallet,
        amount: amount,
        transaction_type: 'credit'
      )

      wallet.update!(balance: wallet.balance + amount)
    end

    render json: { message: 'Deposit successful', balance: wallet.balance }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def transfer
    source_wallet = @current_user.wallet
    target_wallet = Wallet.find(params[:wallet_id])
    amount = params[:amount].to_i

    if source_wallet.id == target_wallet.id
      render json: { error: 'Cannot transfer to the same wallet' }, status: :unprocessable_entity
      return
    end

    if source_wallet.balance < amount
      render json: { error: 'Insufficient balance' }, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      Transaction.create!(
        source_wallet: source_wallet,
        target_wallet: target_wallet,
        amount: amount,
        transaction_type: 'transfer'
      )

      source_wallet.update!(balance: source_wallet.balance - amount)
      target_wallet.update!(balance: target_wallet.balance + amount)
    end

    render json: { message: 'Transfer successful', balance: source_wallet.balance }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def validate_amount
    if params[:amount].blank?
      render json: { error: "Amount parameter is required" }, status: :bad_request
    elsif params[:amount].to_i <= 0
      render json: { error: "Amount must be greater than 0" }, status: :unprocessable_entity
    end
  end
end
