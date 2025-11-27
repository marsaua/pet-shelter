require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    stored_username = Rails.application.credentials.dig(:sidekiq, :username)
    stored_password = Rails.application.credentials.dig(:sidekiq, :password)

    username == stored_username && password == stored_password
  end

  mount Sidekiq::Web => "/sidekiq"

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
    resources :adopts, only: %i[new create index show destroy]
    post :adopt_dog, on: :member
  end

  resources :comments

  get "dogs/:id/requests", to: "adopts#requests", as: :dog_requests

  # Defines the root path route ("/")
  root "pages#home"
  get "about", to: "pages#about"

  resources :placements

  resources :adoption_applications

  resources :shifts

  resources :donations

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords",
    confirmations: "users/confirmations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :reports, only: %i[new create]

  get "profile", to: "pages#profile"
  resources :volunteers do
    collection do
      post :create_event
    end
  end
end
