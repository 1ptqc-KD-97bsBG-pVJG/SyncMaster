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
  delete 'users/:id' => 'users#destroy', as: :delete_user
  
  # Defines the root path route ("/")
  # root "posts#index"
  
  resources :projects do
    member do
      patch :update_video
      patch :close
      patch :request_revision
    end
  end
end
