Rails.application.routes.draw do
  resources :events, only: :create, formats: :json
  resources :get_balances, only: :create
  resources :slack_users, only: :create, formats: :json
  resources :transactions, only: :new

  root to: 'tops#show'
end
