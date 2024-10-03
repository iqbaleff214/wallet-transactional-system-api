Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  post 'login', to: 'sessions#create'
  post 'logout', to: 'sessions#destroy'

  get 'wallet', to: 'transactions#show'
  post 'wallet/debit', to: 'transactions#debit'
  post 'wallet/credit', to: 'transactions#credit'
  post 'wallet/transfer/:wallet_id', to: 'transactions#transfer'
end
