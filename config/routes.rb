Rails.application.routes.draw do
  resources :users, only: [:index, :show] do
    resources :rooms
  end
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  root "home#index"
end
