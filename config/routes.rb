Rails.application.routes.draw do
  root "results#index"

  resources :results, except: [ :show ]
  resource :session
  resources :passwords, param: :token

  get "up" => "rails/health#show", as: :rails_health_check
end
