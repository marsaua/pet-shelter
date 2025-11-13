Rails.application.routes.draw do
  get "adopts/index"
  get "adopts/create"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  resources :dogs do
    resources :comments, only: :create
    resources :adopts, only: [:new, :create, :index, :show, :destroy]
    post :adopt_dog, on: :member
  end

  get "dogs/:id/requests", to: "adopts#requests", as: :dog_requests
  
  # Defines the root path route ("/")
  root "pages#home"
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"


  resources :placements

  resources :adoption_applications

  resources :shifts

  resources :donations

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  get "contact", to: "pages#contact"
  resources :contact_us, only: [:create], controller: "contact_us"
  get "profile", to: "pages#profile"
  resources :volunteers do
    collection do
      post :create_event
    end
  end

end
