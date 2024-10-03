Rails.application.routes.draw do
  get 'users', to: 'users#index'
  get 'teams', to: 'teams#index'
  get 'stocks', to: 'stocks#index'

  post 'login', to: 'sessions#create'
  post 'logout', to: 'sessions#destroy'

  get 'wallet', to: 'transactions#show'
  get 'wallet/debit', to: 'transactions#debit_history'
  get 'wallet/credit', to: 'transactions#credit_history'
  post 'wallet/debit', to: 'transactions#debit'
  post 'wallet/credit', to: 'transactions#credit'
  post 'wallet/transfer/:wallet_id', to: 'transactions#transfer'
end
