class SessionsController < ApplicationController
  before_action :authenticate_request, only: [:show, :destroy, :debit_history, :credit_history, :debit, :credit, :transfer]
  before_action :validate_amount, only: [:debit, :credit, :transfer]

  # Login
  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      token = user.generate_auth_token
      render json: { token: token, message: 'Login successful' }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # Logout
  def destroy
    user = User.find_by(auth_token: request.headers['Authorization'])
    if user
      user.update(auth_token: nil)
      render json: { message: 'Logout successful' }, status: :ok
    else
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end

  # Show balance
  def show
    wallet = @current_user.wallet
    render json: {
      data: wallet.as_json(only: [:id, :balance, :created_at, :updated_at]),
    }, status: :ok
  end

  def debit_history
    wallet = @current_user.wallet
    transactions = wallet.transactions_as_source
    render json: { transactions: transactions }, status: :ok
  end

  def credit_history
    wallet = @current_user.wallet
    transactions = wallet.transactions_as_target
    render json: { transactions: transactions }, status: :ok
  end

  def debit
    wallet = @current_user.wallet
    amount = params[:amount].to_i

    if wallet.balance < amount
      render json: { error: 'Insufficient balance' }, status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      Debit.create!(
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
      Credit.create!(
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
      Transfer.create!(
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
