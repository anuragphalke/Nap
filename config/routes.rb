Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :recommendations, only: [:index]
  resources :articles, only: [:index, :show]

  get "statistics", to: "pages#statistics", as: :statistics
  # Defines the root path route ("/")
  # root "posts#index"



resources :user_appliances, only: [:index, :show, :edit, :new, :create, :destroy] do
    resources :routines, only: [:index, :new, :create] do
      resources :recommendations, only: [:index, :show]
    end
  end

  resources :routines, only: [:show, :update, :edit, :destroy]


  get '/recommend', to: 'recommendations#recommend'

  resources :prices, only: [:index, :create]
end
