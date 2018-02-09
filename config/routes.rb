Rails.application.routes.draw do

  resources :events, only: :create, formats: :json
end
