Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  resources :users, only: [:index, :show] do
    resources :rooms, except: [:index]
  end
  resources :rooms, only: :index
  get "/rooms/search_shop", to: "rooms#search_shop", as: "search_shop"
  root "home#index"
end
