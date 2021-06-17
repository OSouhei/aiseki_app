Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  namespace :api, { format: 'json' } do
    resources :users, only: [:index, :show, :create]
    get "logged_in", to: "users#logged_in"
  end

  resources :users, only: [:index, :show] do
    member do
      get "joining"
      get "follow"
      get "unfollow"
    end
  end

  resources :rooms do
    member do
      get "join"
      get "exit"
      post "bookmark", to: "bookmarks#create"
    end

    collection do
      get "search_shop", as: "search_shop"
      get "search"
    end
  end

  resources :notifications, only: :index
  resources :bookmarks, only: [:index, :destroy]
  root "home#index"
end
