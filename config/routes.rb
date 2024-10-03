Rails.application.routes.draw do
  get 'users', to: 'users#index'
  get 'teams', to: 'teams#index'
  get 'stocks', to: 'stocks#index'

  get 'wallet/:source_wallet_id', to: 'transactions#show'
  get 'transaction/:source_wallet_id/debit', to: 'transactions#debit_history'
  get 'transaction/:source_wallet_id/credit', to: 'transactions#credit_history'
  post 'transaction/debit', to: 'transactions#debit'
  post 'transaction/credit', to: 'transactions#credit'
  post 'transaction/transfer', to: 'transactions#transfer'

  post 'login', to: 'sessions#create'
  post 'logout', to: 'sessions#destroy'

  # FROM CURRENT USER PERSPECTIVE
  # get 'wallet', to: 'sessions#show'
  # get 'wallet/debit', to: 'sessions#debit_history'
  # get 'wallet/credit', to: 'sessions#credit_history'
  # post 'wallet/debit', to: 'sessions#debit'
  # post 'wallet/credit', to: 'sessions#credit'
  # post 'wallet/transfer/:wallet_id', to: 'sessions#transfer'
end
