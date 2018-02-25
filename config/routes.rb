Rails.application.routes.draw do

  get 'transactions/new'

  resources :events, only: :create, formats: :json
  resources :get_balances, only: :create
  resources :slack_users, only: :create, formats: :json
end
