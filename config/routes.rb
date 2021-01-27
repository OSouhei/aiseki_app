Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  get "/rooms/search_shop", to: "rooms#search_shop", as: "search_shop"
  get "/rooms/search", to: "rooms#search"
  resources :users do
    resources :rooms, shallow: true, except: :index
  end
  resources :rooms, only: :index do
    get "join", to: "rooms#join"
  end
  root "home#index"
end
