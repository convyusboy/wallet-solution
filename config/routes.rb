Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :api_keys, path: "api-keys", only: %i[index create destroy]
      resources :users, only: [ :index, :show, :create ]
      resources :transactions, only: [ :index, :show, :create ]
      resources :teams, only: [ :index, :show, :create ]
      resources :wallets, only: [ :index, :show, :create ]
      resources :stocks, only: [ :index, :show, :create ]
      post "deposits", to: "transactions#deposit"
      post "withdraw", to: "transactions#withdraw"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
