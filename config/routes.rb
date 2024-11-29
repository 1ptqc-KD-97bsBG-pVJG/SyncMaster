Rails.application.routes.draw do
  # handles everything related to users (sign in, sign out, create, etc.) (sessions was added for 2fa)
  devise_for :users
  resource :user, only: [:show, :edit, :update]
  
  
  root 'pages#home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  resources :appointments
  
  # users page route:
  get "/users/index" => "users#index"
  resources :users, only: [:show, :edit, :update]
  delete 'users/:id' => 'users#destroy', :as => :delete_user
  
  
  post 'users/duo_verify', to: 'users/sessions#duo_verify', as: :duo_verify

  # Defines the root path route ("/")
  # root "posts#index"
end
