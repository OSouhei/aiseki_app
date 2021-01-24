Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  resources :users do
    resources :rooms, shallow: true
  end
  resources :rooms, only: :index
  get "/rooms/search_shop", to: "rooms#search_shop", as: "search_shop"
  root "home#index"
end
