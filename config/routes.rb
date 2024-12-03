Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :recommendations, only: [:index]
  resources :articles, only: %i[index show]

  get "statistics", to: "pages#statistics", as: :statistics
  # Defines the root path route ("/")
  # root "posts#index"

  get 'profile', to: 'pages#profile', as: 'profile'

  get 'landing', to: 'pages#landing', as: 'landing'

  resources :user_appliances, only: %i[index show edit new create destroy] do
    resources :routines, only: %i[index new create] # do
    #   resources :recommendations, only: [:index, :show]
    # end
  end

  resources :routines, only: %i[create show update edit destroy] do
    resources :recommendations, only: [:index]
  end
  resources :prices, only: %i[index create]

  # New route for all recommendations
  get 'recommendations/all', to: 'recommendations#all', as: :all_recommendations
end
