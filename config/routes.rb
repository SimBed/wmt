Rails.application.routes.draw do
  root "results#index"

  resources :results, except: [ :show ]
  resource :session
  resources :passwords, param: :token

  get "up" => "rails/health#show", as: :rails_health_check
  # route to ping to keep DB connections alive on homeserver
  get "/health", to: proc { ActiveRecord::Base.connection.execute("SELECT 1")
                            [ 200, {}, [ "OK" ] ]
                          }, as: :ping_to_keep_app_awake  
end
