Rails.application.routes.draw do

  resources :events, only: :create, formats: :json
  resources :slack_users, only: :create, formats: :json
end
