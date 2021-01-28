Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  resources :users do
    get "joining", on: :member
  end
  resources :rooms do
    member do
      get "join"
      get "exit"
    end
    collection do
      get "search_shop", as: "search_shop"
      get "search"
    end
  end
  root "home#index"
end
