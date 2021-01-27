Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  # 後で整理
  get "/rooms/search_shop", to: "rooms#search_shop", as: "search_shop"
  get "/rooms/search", to: "rooms#search"
  resources :users
  resources :rooms do
    member do
      get "join"
    end
    # get "join", to: "rooms#join"
  end
  root "home#index"
end
