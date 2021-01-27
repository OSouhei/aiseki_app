Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  resources :users
  resources :rooms do
    get "join", on: :member
    collection do
      get "search_shop", as: "search_shop"
      get "search"
    end
  end
  root "home#index"
end
