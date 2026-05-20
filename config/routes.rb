Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  root "home#index"

  resources :products, only: [:index, :show]

  resource :cart, only: [:show] do
    post :add
    delete :remove
    delete :clear
  end

  resources :orders, only: [:index, :show, :new, :create] do
    member { patch :cancel }
  end

  namespace :api do
    namespace :v1 do
      post "users/sign_in", to: "sessions#create"
      post "users",         to: "registrations#create"
      resources :products,  only: [:index, :show]
      resources :orders,    only: [:index, :show, :create]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end