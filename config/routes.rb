Rails.application.routes.draw do

  resources :events, only: :create, formats: :json
  resource :balance, only: :show
  resources :slack_users, only: :create, formats: :json
end
