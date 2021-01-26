Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  resources :users do
    resources :rooms, shallow: true, except: :index
  end
  resources :rooms, only: :index do
    get "join", to: "rooms#join"
  end
  get "/rooms/search_shop", to: "rooms#search_shop", as: "search_shop"
  root "home#index"
end
