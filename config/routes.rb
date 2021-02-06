Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  resources :users, only: [:index, :show] do
    get "joining", on: :member
  end
  resources :rooms do
    member do
      get "join"
      get "exit"
      resources :bookmarks, only: [:create, :destroy]
    end
    collection do
      get "search_shop", as: "search_shop"
      get "search"
    end
  end
  resources :notifications, only: :index
  root "home#index"
end
