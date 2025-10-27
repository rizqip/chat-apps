Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  get '/csrf-token', to: 'tokens#index'

  # Nickname routes - untuk web interface
  resource :nickname, only: [:new, :create, :destroy]
  root "nicknames#new"
  post "/api/nickname", to: "nicknames#api_create" # Tetap gunakan ini


  # Chat rooms
  resources :rooms do
    resources :room_messages, only: [:create]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end