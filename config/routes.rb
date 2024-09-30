Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "price-all", to: "stock_prices#price_all"
      get "price", to: "stock_prices#price"
      get "prices", to: "stock_prices#prices"
      resources :api_keys, path: "api-keys", only: %i[create destroy]
      resources :users, only: [ :index, :show, :create ]
      resources :deposits, only: [ :index, :show, :create ]
      resources :withdrawals, only: [ :index, :show, :create ]
      resources :transactions, only: [ :index, :show, :create ]
      resources :teams, only: [ :index ]
      resources :wallets, only: [ :index ]
      resources :stocks, only: [ :index ]
      patch "stocks/sell", to: "stocks#sell"
      get "team-wallets", to: "wallets#team_wallet_index"
      post "team-wallets/withdraw", to: "withdrawals#team_wallet_create"
      get "me", to: "api_keys#index"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
