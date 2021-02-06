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
      resources :bookmarks, only: [:create]
    end
    collection do
      get "search_shop", as: "search_shop"
      get "search"
    end
  end
  resources :notifications, only: :index
  resources :bookmarks, only: [:destroy]
  root "home#index"
end
