Rails.application.routes.draw do
  devise_for :users, skip: :all
  devise_scope :user do
    post '/users' => 'users/registrations#create', as: :user_registration
    patch '/users' => 'users/registrations#update'
    delete '/users' => 'users/registrations#destroy'
    post '/users/sign_in' => 'users/sessions#create', as: :user_session
    delete '/users/sign_out' => 'users/sessions#destroy', as: :destroy_user_session
  end

  namespace :api, { format: 'json' } do
    resources :users, only: [:index, :show]
    get "login_user", to: "users#login_user"
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
