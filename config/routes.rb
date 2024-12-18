Rails.application.routes.draw do
  # handles everything related to users (sign in, sign out, create, etc.)
  devise_for :users
  root 'pages#home'
  
  # Health status route
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Appointments routes with download_ical member route
  resources :appointments do
    member do
      get :download_ical
    end
  end
  
  # Users page route
  get "/users/index" => "users#index"
  resources :users, only: [:show, :edit, :update]
  delete 'users/:id' => 'users#destroy', :as => :delete_user

  resources :projects
  get '/all-projects/completed', to: 'projects#completed'
  get '/all-projects/canceled', to: 'projects#canceled'
  get '/all-projects/deleted', to: 'projects#deleted'

  # Defines the root path route ("/")
  # root "posts#index"
end
